##
# = 商城 同义词 表
#
# == Fields
#
# editor_id :: 编辑ID
# name :: 名称
# brand_id :: 品牌ID
# category1_id :: 一级分类ID
# category2_id :: 二级分类ID
# target :: 对象
# color :: 颜色
# published? :: 发布？
# active? :: 有效？
#
# == Indexes
#
# user_id, product_id
#
class Shop::Synonym < ActiveRecord::Base
	self.table_name = :shop_synonyms

	belongs_to :editor, :class_name => "Manage::Editor"
	belongs_to :brand
	belongs_to :category1, :class_name => 'Category'
	belongs_to :category2, :class_name => 'Category'

  scope :active, -> { where :active => true }
  scope :published, -> { where :published => true }

	self.xml_options = { :only => [ :id, :name, :brand_id, :category1_id, :category2_id, :target, :color ] }.freeze
end
