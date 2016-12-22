##
# = 商城 用户更新 表
#
# == Fields
#
# editor_id :: 编辑ID
# user_id :: 用户ID
# trades_amount :: 交易总额
# level_id :: 等级ID
#
# == Indexes
#
class Shop::UsersUpdating < ActiveRecord::Base
	self.table_name = :shop_users_updatings

	belongs_to :user
	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
	belongs_to :level

	def malls #:nodoc: all
		self.mall_ids.to_s.scan(/\d+/).map{|id| Mall.active.find_by_id(id) }.compact
	end
end
