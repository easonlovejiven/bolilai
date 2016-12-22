##
# = 主站 帐号 表
#
# == Fields
#
# email :: 邮件
# crypted_password :: 加密密码
# salt :: salt
# remember_token :: session
# remember_token_expired_at :: session过期时间
# activation_code :: 激活码
# activated_at :: 激活时间
# referrer_id :: 介绍人ID
# shop_id :: 店铺ID
# guide_id :: 导购ID
# source :: 来源
# information :: 附加信息
# link_id :: 链接ID
# active? :: 有效？
#
# == Indexes
#
# email
#
class Core::Account < ActiveRecord::Base
  self.table_name="core_accounts"

  belongs_to :user, foreign_key: 'id', class_name: "Core::User"
  belongs_to :setting, foreign_key: 'id', class_name: "Core::Setting"
  belongs_to :info, foreign_key: 'id', class_name: "Core::Info"
  belongs_to :shop_user, class_name: Shop::User, foreign_key: 'id'
  # belongs_to :link, class_name: Shop::Link
  # belongs_to :click, class_name: Shop::Click
  # belongs_to :latest_link, class_name: Shop::Link, foreign_key: 'latest_link_id'
  # belongs_to :latest_click, class_name: Shop::Click, foreign_key: 'latest_click_id'
  # belongs_to :shop, class_name: Retail::Shop
  # belongs_to :guide, class_name: Retail::Guide
  has_many :connections, -> { where(active: true) }
  has_many :updatings, :class_name => "Core::AccountUpdating"
  accepts_nested_attributes_for :user

  validates_associated :user

  attr_accessor :password_confirmation # deperated

  # index :email
  # index :phone
  # index :ip_address
  # index [:email, :active]
  # index [:phone, :active]

  # define_index do
  # 	indexes user.name, :sortable => true
  # 	indexes user.abbrs
  #
  # 	has created_at
  # 	has user.setting.search_engine_indexing, :as => :search_engine_indexing
  # 	has "CRC32(sex)", :as => "sex_attr", :type => :integer
  # 	has user.birthday, :as => "birthday_attr"
  # 	has info.location_id, :as => "location_id_attr"
  #
  # 	where "active = 1"
  # 	#set_property :delta => :datetime, :threshold => 70.minutes # 定时索引, 默认使用updated_at, 有利于让多个主从数据库分别索引 http://www.engineyard.com/blog/2009/5-tips-for-sphinx-indexing/
  # end if IS_SPHINX_ENABLED

  attr_accessor :password
  # attr_accessible :email, :password, :password_confirmation

  #validates_presence_of :email
  # validates_presence_of :password, :if => :password_required?
  # validates_presence_of :password_confirmation, :if => :password_required?
  # validates_length_of :password, :within => 6..128, :if => :password_required?, :allow_nil => true
  # validates_uniqueness_of :email, :allow_nil => true
  #  validates_format_of :email, :with => /\A[\w\.%\+\-]+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2}|com|org|net|edu|gov|mil|biz|info|mobi|name|aero|jobs|museum)\z/i
  # validates_confirmation_of :password, :if => :password_required?

  validates :phone, uniqueness: true, length: {is: 11}, format: {with: /\A((\(\d{3}\))|(\d{3}\-))?13[0-9]\d{8}?$|15[0-9]\d{8}?$|18[0-9]\d{8}?\z/}, allow_blank: true
  validates :email, uniqueness: true, format: {with: /\A[\w\.]+@[\w\.]+\z/}, allow_blank: true
  # validates :email, presence: true, if: -> { phone.blank? && connections.empty? }
  validates :password, length: {in: 6..128}, if: :password_required?, allow_blank: true

  CLIENTS = %w[manage html5 osx windows linux flash iphone ipad android phone_web ipad_web wechat]

  validates_inclusion_of :client, :in => CLIENTS, :allow_blank => true

  #before_create :make_activation_code

  before_save :encrypt_password

  self.xml_options = {:only => :id, :methods => :auth_token}

  cattr_accessor :get_status_xml_options
  self.get_status_xml_options = {
      :only => [:id].freeze,
      :methods => [:has_password, :has_email, :has_phone, :is_email_activated, :is_phone_activated].freeze,
      :include => {
          :connections => {:only => [:site].freeze}.freeze,
      }.freeze,
  }.freeze

  default_scope { order('id DESC') }
  scope :active, -> { where({:active => true}) }
  scope :promoted, -> { where("activated_at IS NOT NULL") }

  def auth_token #:nodoc: all
    "#{self.id}-#{self.remember_token}"
  end

  def email=(value) #:nodoc: all
    write_attribute :email, (value ? value.downcase : nil)
  end

  def make_reset_code #:nodoc: all
    self.remember_token = "%06d" % rand(1000000)
    self.remember_token_expires_at = Time.new + 0.5.hour
    self.save
  end

  def make_activation_code #:nodoc: all
    self.activation_code = "%06d" % rand(1000000)
  end

  def make_phone_activation_code #:nodoc: all
    return unless self.phone
    self.phone_activation_code = "%06d" % rand(1000000)
    self.phone_activation_code_expired_at = Time.new + 0.5.hour
  end

  def activate! #:nodoc: all
    @activated = true
    self.activated_at ||= Time.now
    self.activation_code = nil
    self.remember_token_expires_at = nil
    save(:validate => false)
  end

  def activate_phone! #:nodoc: all
    @activated = true
    self.phone_activated_at ||= Time.now
    self.phone_activation_code = nil
    self.phone_activation_code_expired_at = nil
    save(:validate => false)
  end

  def recently_activated? #:nodoc: all
    @activated
  end

  def activated? #:nodoc: all
    !self.activated_at.blank?
  end

  def phone_activated? #:nodoc: all
    !self.phone_activated_at.blank?
  end

  def self.authenticate(login, password) #:nodoc: all
    return nil if login.blank? || password.blank?
    u = login.include?('@') ? find_by_email(login) : find_by_phone(login)
    u && u.authenticated?(password) ? u : nil
  end

  def secure_digest(*args) #:nodoc: all
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def make_token #:nodoc: all
    secure_digest(Time.now, (1..10).map { rand.to_s })
  end

  def password_digest(password, salt) #:nodoc: all
    digest = REST_AUTH_SITE_KEY

    REST_AUTH_DIGEST_STRETCHES.times do
      digest = secure_digest(digest, salt, password, REST_AUTH_SITE_KEY)
    end

    digest
  end

  def encrypt(password) #:nodoc: all
    self.password_digest(password, salt)
  end

  def authenticated?(password) #:nodoc: all
    crypted_password == encrypt(password)
  end

  def encrypt_password #:nodoc: all
    return if password.blank?
    self.salt ||= self.make_token
    self.crypted_password = encrypt(password)
  end

  def password_required? #:nodoc: all
    #crypted_password.blank? || !password.blank?
    !password.blank?
  end

  def remember_token?(auth_token) #:nodoc: all
    self.remember_token && self.remember_token == auth_token && self.remember_token_expires_at && Time.now - self.remember_token_expires_at
    #self.remember_token && self.remember_token == auth_token && self.remember_token_expires_at(没勾上”以后自动登录的话“，这个字段在logout_keeping_session! -> forget_me里已经被置为nil了） && Time.now - self.remember_token_expires_at
  end

  def remember_me #:nodoc: all
    remember_me_for 60.days
  end

  def remember_me_for(time) #:nodoc: all
    remember_me_until time.from_now
  end

  def remember_me_until(time) #:nodoc: all
    return if self.remember_token_expires_at && self.remember_token_expires_at > Time.now
    self.remember_token_expires_at = time
    self.remember_token = "%06d" % rand(1000000)
    save(false)
  end

  def forget_me #:nodoc: all
    self.remember_token_expires_at = nil
    self.remember_token = nil
    save(false)
  end

  def reset_code #:nodoc: all
    secure_digest(self.crypted_password).slice(0, 6)
  end

  def send_active_sms #:nodoc: all
    return unless self.phone && self.phone_activation_code
    Shop::Sms.create!(:user_id => self.id, :phone => self.phone, :content => "#{self.phone_activation_code}", :active => false).send_by!(:sign_up, nil)
  end

  def send_active_email #:nodoc: all
    return unless self.email && self.activation_code
    if self.activated_at.nil?
      Core::Mailer.mail(
          :recipients => self.email,
          :subject => "恭喜您成功注册珀丽莱账户",
          :template => 'signup',
          :body => {:user => self.user},
          :from => %["珀丽莱" <#{MAILER_CONFIG['from']['activation']}>]
      )
    else
      Core::Mailer.mail(
          :recipients => self.email,
          :subject => "珀丽莱电子邮件激活",
          :template => 'check',
          :body => {:user => self.user},
          :from => %["珀丽莱" <#{MAILER_CONFIG['from']['activation']}>]
      )
    end
  end

  def send_active_success_sms #:nodoc: all
    return unless (self.phone)
    Shop::Sms.create!(:user_id => self.id, :phone => self.phone, :content => "亲爱的用户，您在珀丽莱官网的手机帐号已经成功激活。", :active => false).send_by!(:service)
  end

  def send_active_success_email #:nodoc: all
    return unless (self.email)
    Core::Mailer.mail(
        :recipients => self.email,
        :subject => "珀丽莱官网账户激活成功",
        :template => 'activated',
        :body => {:account => self}
    )
  end

  def reset_code_valid?(code) #:nodoc: all
    code == self.remember_token && self.remember_token_expires_at && Time.now < self.remember_token_expires_at
  end

  def phone_code_valid?(code) #:nodoc: all
    code == self.phone_activation_code && self.phone_activation_code_expired_at && Time.now < self.phone_activation_code_expired_at
  end

  def self.search_by_params(params = {}) #:nodoc: all
    params.to_h.symbolize_keys!
    id = params[:id] && (params[:id].to_i > 0) && params[:id].to_i
    email = params[:email]
    phone = params[:phone]
    (login = params[:login]) && (login.include?('@') ? (email = login) : (phone = login))
    account = email && self.find_by_email(email) || phone && self.find_by_phone(phone) || id && self.find(id)
    account && account.active? ? account : nil
  end

  def has_password #:nodoc: all
    !self.crypted_password.nil?
  end

  def has_email #:nodoc: all
    !self.email.nil? && self.email !~ /@weimall\.com\.cn/
  end

  def has_phone #:nodoc: all
    self.phone.present?
  end

  def is_email_activated #:nodoc: all
    !self.activated_at.nil?
  end

  def is_phone_activated #:nodoc: all
    !self.phone_activated_at.nil?
  end

  def self.need_captcha?(client_ip) #:nodoc: all
    self.where(["ip_address = :ip_address and created_at > :created_at", {:ip_address => client_ip, :created_at => (Time.now - 24.hour)}]).size >= 3
  end

  EXPORTS = {
      shop: {id: 'id', phone: 'phone', email: 'email', shop_id: -> (account) { account.shop.try(:name) }, guide_id: -> (account) { account.guide.try(:name) }, created_at: 'created_at'}
  }

  def name_for_link
    phone || email || id
  end
end
