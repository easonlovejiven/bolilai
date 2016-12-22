##
# = 商城 图片 表
#
# == Fields
#
# user_id :: 编辑ID
# product_id :: 产品ID
# large :: 大图
# medium :: 中图
# small :: 小图
# description :: 描述
# active? :: 有效？
#
# == Indexes
#
class Shop::Image < ActiveRecord::Base
  self.table_name= :shop_images

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "user_id"
  belongs_to :product
  # attr_accessor :large_image, :large_image_file_name, :large_image_content_type, :large_image_file_size, :large_image_updated_at, :is_page
  # attr_accessor :medium_image, :medium_image_file_name, :medium_image_content_type, :medium_image_file_size, :medium_image_updated_at
  # attr_accessor :small_image, :small_image_file_name, :small_image_content_type, :small_image_file_size, :small_image_updated_at
  mount_uploader :large_image, PhotoUploader, :mount_on => :large

  #
  # has_attached_file :large_image,  :url => "/image/shop/image/:id_partition/large/:fullname", :styles => { :medium => "450x450", :small => "50x50" }
  # has_attached_file :medium_image, :url => "/image/shop/image/:id_partition/medium/:fullname"
  # has_attached_file :small_image, :url => "/image/shop/image/:id_partition/small/:fullname"
  #
  # validates_attachment_content_type :large_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :medium_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :small_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true

  # def large=(file) #:nodoc: all
  # 	self[:large] = file.respond_to?(:content_type) ? (self.large_image = file) && (self.new_record? ? nil : self.large_image.url(:original, false)) : file.blank? ? nil : file
  # end
  #
  # def medium=(file) #:nodoc: all
  # 	self[:medium] = file.respond_to?(:content_type) ? (self.medium_image = file) && (self.new_record? ? nil : self.medium_image.url(:original, false)) : file.blank? ? nil : file
  # end
  #
  # def small=(file) #:nodoc: all
  # 	self[:small] = file.respond_to?(:content_type) ? (self.small_image = file) && (self.new_record? ? nil : self.small_image.url(:original, false)) : file.blank? ? nil : file
  # end
  #
  # after_create do |record|
  # 	[
  # 		record.large_image.file? && (record[:large] = record.large_image.url(:original, false)),
  # 		record.medium_image.file? && (record[:medium] = record.medium_image.url(:original, false)),
  # 		record.small_image.file? && (record[:small] = record.small_image.url(:original, false)),
  # 	].inject{|a,b|a||b} && record.save
  # end
end
