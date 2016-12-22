##
# = 主站 积分关系 表
#
# == Fields
#
# user_id :: 用户ID
# point :: 总积分
# gene_point :: 基因积分
# auction_point :: 交易积分
# increment :: 增量
# description :: 说明
#
# == Indexes
#
class Core::Transaction < ActiveRecord::Base
	self.table_name = :core_transactions

	# index [ :user_id, :trade_id ]

	has_one :trade, :foreign_key => :id,class_name: "Core::Trade"
	has_one :user,class_name: "Core::User"
	belongs_to :user,class_name: "Core::User"
	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"

  scope :active, -> { where active: true }
end
