##
# = 商城 属性值 表
#
# == Fields
#
# editor_id :: 编辑ID
# product_id :: 产品ID
# attribute_id :: 属性ID
# attribute_name :: 属性名称
# content :: 内容
# active? :: 有效？
#
# == Indexes
#
# prouduct_id
# attribute_id
# category1_id, attribute_id
# category2_id, attribute_id
#
class Shop::Value < ActiveRecord::Base
  self.table_name= :shop_values

  belongs_to :product
  belongs_to :attribute_obj,class_name: "Shop::Attribute",foreign_key: :attribute_id

  def self.tags #:nodoc: all
    self.select("content, COUNT(*) AS cnt").where("attribute_name = 'TAG'").group("content").order("cnt DESC").limit(100)
  end

  class<<self
    def active
      where(active: true)
    end
  end
end
