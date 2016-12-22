##
# = 商城 产品更新 表
#
# == Fields
#
# product_id :: 产品ID
# editor_id :: 编辑ID
# data :: 数据
# published? :: 发布？
#
# == Indexes
#
class Shop::ProductsUpdating < ActiveRecord::Base
	self.table_name = "shop_products_updatings"

	belongs_to :product
	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
end
