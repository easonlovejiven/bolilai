##
# = 商城 收藏 表
#
# == Fields
#
# user_id :: 用户ID
# product_id :: 产品ID
# active? :: 有效？
#
# == Indexes
#
# user_id, product_id
#
class Shop::Favorite < ActiveRecord::Base
	self.table_name = :shop_favorites

	belongs_to :user
	belongs_to :product

  scope :active, -> { where(active: true) }

	self.xml_options = { :except => [ :active, :user_id, :created_at, :lock_version ] }
end
