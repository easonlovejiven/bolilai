##
# = 商城 页面页面
#
# == Fields
#
# page_id :: 页面ID
# child_id :: 子页面ID
# active? :: 有效
#
# == Indexes
#
class CustomPage::PagesPage < ActiveRecord::Base
  self.table_name = "custom_page_pages_pages"

  belongs_to :page, :class_name => 'CustomPage::Page'
	belongs_to :child, :class_name => 'CustomPage::Page'

	# validates_existence_of :page_id, :allow_blank => true
	# validates_existence_of :child_id, :allow_blank => true

	scope :active, ->{where :active => true }

	cattr_accessor :manage_fields
	self.manage_fields = %w[child_id]
end
