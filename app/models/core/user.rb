##
# = 主站 用户 表
#
# == Fields
#
# pic :: 头像
# name :: 名字
# sex :: 性别
# birthday :: 生日
#
# == Indexes
#
class Core::User < ActiveRecord::Base

  self.table_name= "core_users"
  mount_uploader :pic_key, AvatarUploader, :mount_on => :pic

  #validates_presence_of        :name
  #validates_length_of          :name #, :within => 2..4 # TODO 最多六个汉字，二十个英文，中文英文都算一个
  #validates_presence_of        :sex
  validates_inclusion_of :sex, :in => ['male', 'female'], :allow_nil => true
  #validates_presence_of        :birthday

  belongs_to :account, :foreign_key => "id", class_name: "Core::Account"
  has_one :info, :foreign_key => "id", class_name: "Core::Info"
  belongs_to :setting, :foreign_key => "id", :autosave => true, :class_name => "Core::Setting"
  belongs_to :shop_user, :foreign_key => "id", :class_name => "Shop::User"

  # has_many :feeds, :foreign_key => :source_id, :order => "id DESC"
  # has_many :streams, :foreign_key => :source_id #, :order => "updated_at DESC"
  has_many :comments
  # has_many :affiliations, :autosave => true, :order => "started_at DESC"
  # has_many :college_affiliations, :conditions => "`core_affiliations`.`college_id` IS NOT NULL", :class_name => "Core::Affiliation"
  # has_many :network_affiliations, :conditions => "`core_affiliations`.`network_id` IS NOT NULL", :class_name => "Core::Affiliation"
  # has_many :colleges, :through => :affiliations, :conditions => "`core_affiliations`.`college_id` IS NOT NULL", :source => "college" #, :class_name => "Core::College"
  # has_many :networks, :through => :affiliations, :conditions => "`core_affiliations`.`network_id` IS NOT NULL", :source => "network" #, :class_name => "Core::Network"
  # has_many :authorizations
  # has_many :apps, :through => :authorizations
  # has_many :lists
  delegate :cart_data, to: :shop_user, allow_nil: true

  def grouped_lists # :nodoc: all
    _lists = self.lists.active.non_default
    results = (%w[家人 同事 同学 朋友] - _lists.map(&:name)).map { |name| Core::List.new(:name => name, :user_id => self.id, :is_default => true) } + _lists
    ids = (self.friend_ids - results.map(&:friend_list).map { |x| x.to_s.split(',') }.flatten.map(&:to_i)).join(',')
    results.unshift Core::List.new(:name => '默认', :friend_list => ids, :user_id => self.id, :is_default => true)
  end

  has_many :logins
  has_many :links # 在core_links加了content_type，故注释以下拆分
  #has_many :share_pages, :class_name => "Share::Page"
  #has_many :share_images, :class_name => "Share::Image"
  #has_many :share_audios, :class_name => "Share::Audio"
  #has_many :share_videos, :class_name => "Share::Video"
  has_many :trades, class_name: "Shop::Trade"
  has_many :transactions, class_name: "Shop::Transaction"
  has_many :inbox
  # has_many :messages, :through => :inbox, :order => "id DESC"
  # has_many :unreads, :through => :inbox, :source => :message, :conditions => ["unread = ?", true], :order => "id DESC"
  # has_many :receives, :through => :inbox, :source => :message, :conditions => ["receive = ?", true], :order => "id DESC"
  # has_many :sents, :through => :inbox, :source => :message, :conditions => ["sent = ?", true], :order => "id DESC"
  # has_many :requests, :class_name => "Core::Request", :foreign_key => :receiver_id
  #has_many :notifications, :foreign_key => :receiver_id,:order => "id DESC"
  #has_many :unread_notifications,:class_name => "Core::Notification", :foreign_key => :receiver_id, :conditions => ["unread = ?", true]
  # has_many :status, :class_name => "Core::Status", :order => "created_at DESC"
  # has_many :shares, :class_name => "Core::Share", :order => "created_at DESC" do
  # 	def recent(limit=3)
  # 		find(:all, :limit => limit, :order => 'id desc')
  # 	end
  # end
  # has_many :friendships, :conditions => ["core_friendships.active = ?", true ]
  # has_many :friends, :conditions => ["core_friendships.active = ?", true ], :through => :friendships, :source => :relate
  # has_many :visits
  # has_many :visitors, :through => :visits, :source => :relate
  # has_many :similarities
  # has_many :similars, :through => :similarities, :source => :relate
  # has_many :hidings
  # has_many :hides, :through => :hidings, :source => :relate
  # has_many :blockings
  # has_many :blocks, :through => :blockings, :source => :relate
  # has_many :invitations, :conditions => { :active => true }
  has_many :reports
  has_many :updatings, :class_name => "Core::UserUpdating"
  has_many :readings, :class_name => "Core::UserReading"

  scope :classmates, lambda { |college_id, user_id|
                     where(["id IN (#{ids = Core::Affiliation.find_all_by_college_id(college_id).map { |aff| aff.user_id }; ids.delete(user_id); ids.join(','); ids.empty? ? "''" : ids})"])
                   }
  scope :workmates, lambda { |network_id, user_id|
                    where(["id IN (#{ids = Core::Affiliation.find_all_by_network_id(network_id).map { |aff| aff.user_id }; ids.delete(user_id); ids.join(','); ids.empty? ? "''" : ids})"])
                  }

  self.xml_options = {
      :only => [:id, :pic, :name, :sex, :birthday],
      :include => {
          :info => Core::Info.xml_options
          # :setting => Core::Setting.xml_options
          # :affiliations => Core::Affiliation.xml_options
      }
  }

  def setting # :nodoc: all
    setting = Core::Setting.where(id: self.id).first_or_initialize
    setting.profile ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.friend ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.feed ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.basic ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.personal ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.work ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.im ||= {:value => 'ALL_FRIENDS', :allow => '', :deny => ''}.to_json
    setting.mobile ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.phone ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.website ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.email ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.search ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.note ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.photo ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.share ||= {:value => 'EVERYONE', :allow => '', :deny => ''}.to_json
    setting.my_profile_picture = true if setting.my_profile_picture == nil
    setting.my_friend_list = true if setting.my_friend_list == nil
    setting.a_link_to_add_me_as_a_friend = true if setting.a_link_to_add_me_as_a_friend == nil
    setting.a_link_to_send_me_a_message = true if setting.a_link_to_send_me_a_message == nil
    setting.search_engine_indexing = true if setting.search_engine_indexing == nil
    setting.sends_me_a_message = true if setting.sends_me_a_message == nil
    setting.adds_me_as_a_friend = true if setting.adds_me_as_a_friend == nil
    setting.confirms_a_friendship_request = true if setting.confirms_a_friendship_request == nil
    setting.suggests_a_friend_to_me = true if setting.suggests_a_friend_to_me == nil
    setting.adds_a_friend_i_suggested = true if setting.adds_a_friend_i_suggested == nil
    setting.i_invited_joins_facebook = true if setting.i_invited_joins_facebook == nil
    setting.has_a_birthday_coming_up = true if setting.has_a_birthday_coming_up == nil
    setting.pokes_me = true if setting.pokes_me == nil
    setting.posts_on_my_wall = true if setting.posts_on_my_wall == nil
    setting.comments_on_a_story_in_my_wall = true if setting.comments_on_a_story_in_my_wall == nil
    setting.comments_after_me_on_a_wall_story = true if setting.comments_after_me_on_a_wall_story == nil
    setting.public_online_status = true if setting.public_online_status == nil
    setting.receive_promotion_email = true if setting.receive_promotion_email == nil
    setting
  end

  def uid # :nodoc: all
    id
  end

  def age # :nodoc: all
    ((Time.now - (self.birthday || Time.now).to_time)/1.year).to_i
  end

  def info # :nodoc: all
    Core::Info.where(id: self.id).first_or_initialize
  end

  def to_attachment # :nodoc: all
    {
        :name => self.name,
        :href => "/profile/#{self.id}",
        :media => [
            {
                :type => "image",
                :src => self.pic_n,
                :href => "/profile/#{self.id}",
            }
        ],
        :object_id => self.id,
        :object_type => 'user',
    }
  end

  def top_apps # :nodoc: all
    # ([4,5,2,3].map{|id| App.find(id) } + self.apps).uniq
    [6, 4, 5, 2, 3, 9, 16, 11].map { |id| App.find(id) }
  end

  # 好友新鲜事 nf : news feed
  # 个人新鲜事 pp : public profile
  def news_feeds(options) # :nodoc: all
    Core::Feed.find self.streams._where(options[:where])._order(options[:order]).recently(options).paginate(:page => options[:page], :per_page => (options[:per_page] || 20)).map(&:feed_id)

    #rescue ActiveRecord::RecordNotFound
    #path = RAILS_ROOT + '/app/models/'
    #(Dir[path + '*/*.rb'] + Dir[path + '*/*/*.rb']).map {|f| File.read(f) }.map {|l| l.split("\n").grep(/^class/) }.flatten.map {|s| s.split[1] }.map(&:constantize).select {|m| m.respond_to?(:columns_hash) }.reject {|m| m.to_s =~ /^content|reading$|updating$|activerecord/i }.select {|m| m.columns_hash['active'] }.each do |model|
    #model.all.each {|r| r.update_attribute(:active, true) if r.active.nil? }
    #end
    ##Feed.active.find_all_by_id( self.streams.recently(options).map(&:feed_id).uniq ).paginate :page => options[:page], :per_page => (options[:per_page] || 20), :order => "ID DESC"
    #Core::Feed.find self.streams._where(options[:where])._order(options[:order]).recently(options).paginate(:page => options[:page], :per_page => (options[:per_page] || 20)).map(&:feed_id)
  end

  def friend_list # :nodoc: all
    self.friend_ids.join(',')
  end

  def is_a_friend_of?(user) # :nodoc: all
    user.friend_ids.index id
  end

  # 他(user)和我(self)是否有共同好友
  # @param [Core::User] 他
  # @return [Array(Core::User)] 共同好友集合
  def common_friends_of(user) # :nodoc: all
    my_friend_ids = Core::Friendship.find(:all, :conditions => {:user_id => self.id}).map { |s| s.relate_id }
    his_fried_ids = Core::Friendship.find(:all, :conditions => {:user_id => user.id}).map { |s| s.relate_id }
    #OPTIMIZE 单独执行以上语句，可被cache_money缓存命中，但是一块执行时SQL中会包含IN导致缓存失效
    ids = my_friend_ids & his_fried_ids
    ids.any? ? User.find(ids) : []
  end

  # 他(user)和我(self)有几个共同
  # ＠param [Core::User] 他
  # @return [Fixnum] 共同好友的个数
  def common_friends_size_of(user) # :nodoc: all
    common_friends_of(user).size
  end

  # 谁和我有共同好友
  def who_has_common_friends_with_me(options={:limit => 5}) # :nodoc: all
    key = id.to_s << "who_has_common_friends_with_me"
    #data_in_cache = data_cache(key) {
    data_in_cache = proc {
      ids = Core::Friendship.find_by_sql(%Q{
				SELECT user_id,count(user_id) as num_of_common_friends FROM core_friendships
				WHERE
				relate_id
				IN (
				SELECT relate_id
				FROM
				core_friendships
				WHERE user_id = #{id}
				)
				AND user_id <> #{id}
				GROUP BY user_id
				ORDER BY num_of_common_friends DESC
				LIMIT #{options[:limit]}
                                         }).map { |s| s.user_id }
      users = ids.blank? ? [] : Core::User.find(ids)
    }.call
  end

  def become_a_friend_of(user) # :nodoc: all
    Friendship.find_or_create_by_user_id_and_relate_id_and_active(self.id, user.id, true)
    Friendship.find_or_create_by_user_id_and_relate_id_and_active(user.id, self.id, true)
  end

  def visited_by(user) # :nodoc: all
    return if !user
    return if self == user

    self.visitors.push(user) unless self.visitor_ids[0..5].include?(user.id)
  end

  def block_with(user) # :nodoc: all
    return if !user
    return if self == user
    return if self.is_a_friend_of?(user)

    self.blocks.push(user)
  end

  def break_with(user) # :nodoc: all
    return if !user
    return if self == user
    return if !self.is_a_friend_of?(user)

    #self.friends.delete(user)
    #user.friends.delete(self)
    self.friendships.select { |fs| fs.relate_id == user.id }[0].destroy_softly
    user.friendships.select { |fs| fs.relate_id == self.id }[0].destroy_softly
  end

  def login_today(ip_address) # :nodoc: all
    login = Core::Login.where(user_id: self.id, login_on: Time.now.to_date).first_or_initialize
    login.ip_address ||= ip_address
    account.last_login_on = Date.today
    account.save if account.changed?
    login.save if login.changed?
  end

=begin
  #Hiding停用
  def friend_feeds
    hiding_group = Hiding.find_all_by_user_id(self.id).map{ |u| u.relate_id }
    ids = self.friend_ids+[self.id]-hiding_group
    ids.empty? ? [] : Feed.all(:conditions => "source_id IN (#{(ids).join(',')})", :order => "created_at DESC", :limit => 20)
  end
=end

  def friend_status # :nodoc: all
    ids = self.friend_ids
    ids.empty? ? [] : Status.all(:conditions => "user_id IN (#{ids.join(',')})", :order => "created_at DESC", :limit => 20)
  end

  def friend_shares # :nodoc: all
    ids = self.friend_ids
    ids.empty? ? [] : Share.all(:conditions => "user_id IN (#{ids.join(',')})", :order => "created_at DESC", :limit => 20)
  end

  def success_invite(options={}) # :nodoc: all
    user = options[:invitee]
    return if !user
    return if self == user

    invitation = Invitation.find_or_initialize_by_user_id_and_email(self.id, user.account.email)
    invitation.invitee_id = user.id
    invitation.app_id = options[:app_id]
    invitation.save

    self.become_a_friend_of(user)

    Talk::Notification.deliver(
        :receiver => self,
        :app_id => 1,
        :content => %[<a href="/profile/#{user.id}">#{user.name}</a> 接受了你的邀请，并自动成为好友。]
    ) if self.setting.i_invited_joins_facebook?
  end

  def invite_code # :nodoc: all
    self.account.secure_digest(self.id, self.created_at, self.account.salt, REST_AUTH_SITE_KEY)
  end

  def invite_path # :nodoc: all
    "/signup/#{self.id}/#{self.invite_code}"
  end

  def invitation_of(email) # :nodoc: all
    Invitation.find_by_email_and_user_id(email, self.id) || Invitation.create(:user_id => self.id, :email => email, :code => self.account.secure_digest(email, self.id, self.created_at, Time.now.to_i.to_s))
  end

  def available_invitations_count # :nodoc: all
    count = self.invite_count
    count = nil if count == 0
    count ||= (self.info.point || 0)/1000
    count -= self.invitations.count
    count = 0 if count < 0
    count
  end

  def email_invite_code_and_path # :nodoc: all
    code = self.account.secure_digest(self.id, self.created_at, Time.now.to_i.to_s, (rand(200)*rand).to_s)
    path = make_invite_path(code)
    return {:code => code, :path => path}
  end

  ##
  # 是否邮件邀请过某邮件地址
  # @param  [String] 邮件地址
  # @return [NilClass] 没有
  # @return [String] 邀请URI
  def has_email_invite?(email) # :nodoc: all
    invitation = Core::Invitation.find_by_email_and_user_id(email, self.id)
    if invitation
      return make_invite_path(invitation.invite_code)
    else
      return nil
    end
  end


  def do_transaction(bonus, description) # :nodoc: all
    begin
      ActiveRecord::Base.transaction do
        do_transaction!(bonus, description)
      end
      true
    rescue => e
      false
    end
  end

  def do_transaction!(bonus, description) # :nodoc: all
    info = Core::Info.find(self.id)
    info.auction_point = info.auction_point.to_i + bonus.to_i
    info.point = info.auction_point.to_i + info.gene_point.to_i
    info.save!

    transaction = Core::Transaction.create!(
        :user_id => self.id,
        :gene_point => info.gene_point,
        :point => info.point,
        :auction_point => info.auction_point,
        :incremented => bonus,
        :description => description
    )
  end


  def truncation_chart # :nodoc: all
    path = 'public'+self.pic
    image = Magick::Image.read(path).first
    h = image.columns
    w = image.rows
    image.resize(200, 200*w/h).write(path + ".n.jpg")
    image.resize(100, 100*w/h).write(path + ".s.jpg")
    image.resize(50, 50*w/h).write(path + ".t.jpg")
    (h < w ? image.crop(0, 0, h, h) : image.crop((h/2 - w/2), 0, w, w)).strip!.resize(50, 50).write(path + ".q.jpg")
  end

  def messages_delete(message) # :nodoc: all
    Core::Inbox.find_by_user_id_and_message_id(self.id, message.id).destroy
  end

  def allow?(user, method) # :nodoc: all
    privacy = ActiveSupport::JSON.decode(self.setting.send(method))
    case privacy['value']
      when "EVERYONE"
        true
      when "FRIENDS_OF_FRIENDS"
        user == self || user && (!(self.friend_ids & user.friend_ids).empty? || Friendship.find_by_user_id_and_relate_id(self.id, user.id))
      when "ALL_FRIENDS"
        user == self || user && Friendship.find_by_user_id_and_relate_id(self.id, user.id)
      when "SOME_FRIENDS"
        user == self || user && !privacy['deny'].split(',').include?(user.id.to_s) && Friendship.find_by_user_id_and_relate_id(self.id, user.id)
      when "CUSTOM"
        user == self || user && !privacy['deny'].split(',').include?(user.id.to_s) && privacy['allow'].split(',').include?(user.id.to_s)
      when "SELF"
        user == self
      else
        user == self
    end
  end

  def male?;
    sex == 'male'
  end

  # :nodoc: all
  def female?;
    sex == 'female'
  end

  # :nodoc: all

  after_create :create_abbr

  # 生成拼音缩略
  def name_abbr(name = nil) # :nodoc: all
    @name = (name ||= self.name.to_s)
    unicode = @name.scan(/./)
    return if @name.size == unicode.size
    @name = unicode[0..3].join

    pinyins = Pinyin.t(@name).split
    # pinyins => ["chen", "da", "wei"]
    array = []
    pinyins.each_with_index do |han, index|
      array[index] = []
      han.size.times { |num| array[index] << han[0..(num - 1)] }
    end
    # array => [["chen", "c", "ch", "che"], ["da", "d"], ["wei", "w", "we"]]

    as = []
    array.size.times do |x|
      sub_array = []

      array.each_with_index do |ele, i|
        ni = i + x
        sub_array << array[i..ni] if array[ni]
      end

      sub_array.each do |arr|
        while arr.size > 1
          sub_as = []
          arr[0].each { |a1| arr[1].each { |a2| sub_as << (a1 + a2) } }
          arr[0..1] = [sub_as]
        end
        as << arr
      end

    end
    # as => [[["chen", "c", "ch", "che"]], [["da", "d"]], [["wei", "w", "we"]], [["chenda", "chend", "cda", "cd", "chda", "chd", "cheda", "ched"]], [["dawei", "daw", "dawe", "dwei", "dw", "dwe"]], [["chendawei", "chendaw", "chendawe", "chendwei", "chendw", "chendwe", "cdawei", "cdaw", "cdawe", "cdwei", "cdw", "cdwe", "chdawei", "chdaw", "chdawe", "chdwei", "chdw", "chdwe", "chedawei", "chedaw", "chedawe", "chedwei", "chedw", "chedwe"]]]

    as.flatten.join(',')
  end

  def create_abbr # :nodoc: all
    # self.update_attribute :abbrs, self.name_abbr
  end
end

class ActiveRecord::Base # :nodoc: all
  %w[n s t q].each do |s|
    class_eval <<-RUBY
		def pic_#{s}
			self.pic ? self.pic + ".#{s}.jpg" : "/images/shared/\#{self.sex}_#{s}.gif"
		end
    RUBY
  end
end


__END__
	define_index do
		indexes :name, :sortable => true, :facet => true
		has created_at
		# 查找同学
		indexes colleges(:name), :facet => true, :as => "college_name"
		indexes college_affiliations(:profession), :as => "college_profession"
		has colleges(:id), :as => "college_id_attr"
		has college_affiliations.started_at, :as => "college_started_at_attr"
		# 查找同事
		indexes networks(:name), :facet => true, :as => "network_name"
		indexes network_affiliations(:profession), :as => "network_professtion"
		has networks(:id), :as => "network_id_attr"
		# 按姓名查找
		# ts不能依靠Model#method来生成对应的sql语句，必须声明model之间的关系。
		has info.hometown_id, :as => "hometown_id_attr"
		has info.location_id, :as => "location_id_attr"
		has "CRC32(sex)", :as => "sex_attr", :type => :integer
		has birthday, :as => "birthday_attr"
		# 帐号精确查找
		has :id, :as => "id_attr"
		indexes account.email, :as => "email"

		set_property :delta => :datetime, :threshold => 24.hour  # 定时索引, 默认使用updated_at, 有利于让多个主从数据库分别索引 http://www.railsfire.com/article/5-tips-sphinx-indexing
	end if defined?(IS_SPHINX_ENABLED) && IS_SPHINX_ENABLED
