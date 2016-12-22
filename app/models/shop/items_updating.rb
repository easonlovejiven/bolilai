##
# = 商城 单件更新 表
#
# == Fields
#
# item_id :: 单件ID
# editor_id :: 编辑ID
# published? :: 发布？
#
# == Indexes
#
class Shop::ItemsUpdating < ActiveRecord::Base
	self.table_name= :shop_items_updatings

	belongs_to :item
	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
end
