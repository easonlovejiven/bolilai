##
# = 商城 页面图片 表
#
# == Fields
#
# page_id :: 页面ID
# pic :: 图片
# active? :: 有效？
#
# == Indexes
#
class CustomPage::Image < ActiveRecord::Base
	self.table_name = "custom_page_page_images"

	belongs_to :page, :class_name => "CustomPage::Page"
	scope :active, ->{ where  :active => true }
	# validates_existence_of :page_id, :allow_blank => true

	cattr_accessor :manage_fields
	self.manage_fields = %w[page_id pic]

	# attr_accessor :pic_attachment, :pic_attachment_file_name, :pic_attachment_content_type, :pic_attachment_file_size, :pic_attachment_updated_at
	# has_attached_file :pic_attachment,  :url => "/image/auction/pages/image/:id_partition/pic/:fullname"
	# validates_attachment_content_type :pic_attachment, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  mount_uploader :pic_image, PhotoUploader, :mount_on => :pic

  # validates_each :pic do |model, attr, value|
	# 	if error = model.errors.on(:pic_attachment_content_type)
	# 		model.errors.add(:pic, error)
	# 	end
	# end


	after_create do |record|
	end
end
