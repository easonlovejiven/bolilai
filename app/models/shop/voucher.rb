##
# = 商城 代金券 表
#
# == Fields
#
# event_id :: 活动ID
# editor_id :: 编辑ID
# user_id :: 用户ID
# trade_id :: 交易ID
# identifier :: 编号
# obtained_at :: 获得时间
# used_at :: 使用时间
# remark :: 备注
# active? :: 有效？
#
# == Indexes
#
# active, user_id
# trade_id
# active, event_id
#
class Shop::Voucher < ActiveRecord::Base
  self.table_name = :shop_vouchers

  belongs_to :user
  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
  belongs_to :event
  belongs_to :trade

  validates_uniqueness_of :identifier, :allow_blank => true
  validates_each :identifier, :on => :create, :allow_blank => true, :if => Proc.new { |record| record.active? } do |record, attr, value|
    record.errors.add attr, 'has already been taken' if !value.match(/^\d+$/) && record.class.active.where(["identifier LIKE BINARY(?)", "____#{value.gsub(/^.{4}|.{4}$/, '')}____"]).first
  end

  scope :active, -> { where :active => true }
  scope :used, -> { where "trade_id IS NOT NULL" }
  scope :obtain, -> { where "user_id IS NOT NULL" }
  scope :avalable, -> { joins(:event).where(["shop_vouchers.trade_id IS NULL AND :current BETWEEN shop_events.created_at AND shop_events.ended_at", {current: Time.current}]) }

  cattr_accessor :manage_fields
  self.manage_fields = %w[event_id user_id remark]

  def used?
    self.trade_id.blank?
  end

  def expired?
    self.event.ended_at < Time.current
  end

  def available?
    self.trade_id.blank? && !self.expired?
  end

  def deletable?
    true
  end

  def self.find_by_user_product(user,product)
    self.avalable.order("amount desc").where(["shop_events.limitation>=?",product.discount])
  end

  self.xml_options = {
    :only => [:id, :event_id, :user_id, :trade_id, :identifier, :obtained_at],
    :include => {
      :event => {
        :only => [:id, :name, :description, :amount, :limitation, :started_at, :ended_at],
      },
    },
  }
end
