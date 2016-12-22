##
# = 商城 活动 表
#
# == Fields
#
# editor_id :: 编辑ID
# name :: 名称
# description :: 描述
# amount :: 金额
# limitation :: 限制
# price :: 价格
# started_at :: 开始时间
# ended_at :: 结束时间
# active? :: 有效？
#
# == Indexes
#
class Shop::Event < ActiveRecord::Base
  self.table_name = :shop_events

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
  has_many :vouchers

  scope :active, -> { where :active => true }
  scope :published, -> { where :published => true }
  scope :effective, -> { where ["started_at < ? && ? < ended_at", Time.now, Time.now] }
  scope :unexpired, -> { where ["ended_at > ?", Time.now] }

  self.xml_options = {
      :only => [:id, :name, :description, :amount, :limitation, :price, :started_at, :ended_at],
  }

  GENRES = [
      {:value => 'internal', :name => '站内渠道'},
      {:value => 'external', :name => '站外渠道'},
      {:value => 'promotion', :name => '促销支持'},
      {:value => 'customer', :name => '客户关系'},
  ]

  validates_inclusion_of :genre, :in => GENRES.map { |g| g[:value] }, :allow_blank => true

  def view_display
    "单件商品满#{self.limitation}元减#{self.amount}"
  end

  def view_display_simple
    "满#{self.limitation}元减#{self.amount}"
  end
end
