##
# = 商城 属性 表
#
# == Fields
#
# editor_id :: 编辑ID
# name :: 名称
# option_list :: 选项列表，用换行分隔
# searchable? :: 可搜索？
# active? :: 有效？
# == Indexes
#
class Shop::Attribute < ActiveRecord::Base
  self.table_name=:shop_attributes

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
  has_many :values

  def deletable? #:nodoc: all
    self.values.active.empty?
  end

  cattr_accessor :manage_fields
  self.manage_fields = %w[name option_list searchable]

  class<<self
    def active
      where(active: true)
    end
  end
end
