##
# = 商城 地址 表
#
# == Fields
#
# user_id :: 用户ID
# editor_id :: 编辑ID
# name :: 名字
# country :: 国家
# province :: 省份
# city :: 城市
# town :: 区县
# address :: 地址
# postcode :: 邮编
# phone :: 电话
# mobile :: 手机
# delivery_service :: 快递服务
# remark :: 备注
# active? :: 有效？
#
# == Indexes
#
class Shop::Contact < ActiveRecord::Base
  self.table_name = "shop_contacts"

  belongs_to :user
  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
  scope :active, -> { where active: true }

  validates :name, :address, presence: true
  # validates :phone, format: {with: /^[\d-]+$/}, allow_blank: true
  # validates :mobile, format: {with: /^1\d{10}$/}, allow_blank: true
  validates :mobile, presence: true, if: -> { phone.blank? }
  # validates :country, inclusion: Auction::Country.pluck(:name)
  # validates :province, inclusion: Auction::Province.pluck(:name)
  # validates :city, inclusion: Auction::City.pluck(:name)
  # validates :town, inclusion: Auction::Town.pluck(:name), allow_blank: true
  # validates :editor, existence: true, allow_blank: true

  self.xml_options = {:except => [:remark, :delivery_service, :active, :destroyed_at]}

  def self.manage_fields;
    %w[name country province city town address postcode phone mobile];
  end

  def locations
    "#{self.country}#{self.province}#{self.city}#{self.town}"
  end
end
