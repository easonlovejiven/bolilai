##
# = 商城 单件 表
#
# == Fields
#
# user_id :: 编辑ID
# product_id :: 产品ID
# trade_id :: 交易ID
# measure :: 尺寸
# erp_measure :: ERP尺寸
# identifier :: 编号
# remark :: 备注
# purchase_type :: 采购类型
# storage_at :: 入库时间
# expired_at :: 过期时间
# origin :: 产地
# published? :: 发布？
# active? :: 有效？
#
# == Indexes
#
class Shop::Item < ActiveRecord::Base
	self.table_name= :shop_items

	validates_uniqueness_of :identifer, :message => "编号不能重复", :allow_blank => true

	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "user_id"
	belongs_to :product
	belongs_to :trade
	has_many :updatings, :class_name => 'ItemsUpdating'

	delegate :category2, :to => :product, :allow_nil => true
	scope :active, ->{where(active: true )}
  scope :published,->{where(published: true )}
  scope :unpublished,  ->{where({:published => false })}
  scope :unsold,  ->{where("trade_id IS NULL")}
  scope :sold,  ->{where("trade_id IS NOT NULL")}

	PURCHASE_TYPES = { 5 => '采购入库', 7 => '代销入库' }

	def select_item #:nodoc: all
		[self.id, self.measure].join('---')
	end

	def deletable? #:nodoc: all
		self.trade_id.nil?
	end

	def standard_measure #:nodoc: all
		measure
	end
end
