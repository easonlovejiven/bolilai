##
# = 商城 礼品卡 表
#
# == Fields
#
# user_id :: 用户ID
# name :: 名称
# number :: 号码
# password :: 密码
# value :: 价值（1..10000）
# price :: 价格
# balance :: 余额
# started_at :: 开始时间
# ended_at :: 结束时间
# remark :: 备注
# editor_id :: 编辑
# published? :: 发布
# active? :: 有效
#
# == Indexes
#
class Shop::Card < ActiveRecord::Base
  self.table_name = "shop_cards"
	belongs_to :user
	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"

	scope :active, ->{where :active => true }
  scope :published,->{where  :published => true }

	# validates_existence_of :user_id, :allow_blank => true
	validates_numericality_of :value, :only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 20000, :allow_blank => true
	validates_numericality_of :price, :allow_blank => true
	validates_each :number, :on => :create, :allow_blank => true, :if => Proc.new { |record| record.active? } do |record, attr, value|
		record.errors.add attr, 'has already been taken' if record.class.active.scoped(:conditions => ["number LIKE BINARY(?)", "____#{value.gsub(/^.{4}/, '')}"]).first
	end

	cattr_accessor :manage_fields
	self.manage_fields = %w[name price remark]

	self.xml_options = { :only => [:id, :name, :number, :value, :balance, :started_at, :ended_at] }

	CHARACTERS = ('0'..'9').to_a + %w[A B D E F G H M N Q R T Y a b d e f h m n r t y]

	def deletable?
		!self.user
	end

end
