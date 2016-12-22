##
# = 商城 视频 表
#
# == Fields
#
# editor_id :: 编辑ID
# product_id :: 产品ID
# mp4 :: mp4文件
# flv :: flv文件
# swf :: swf文件
# description :: 描述
# has_audio? :: 有音频？
# active? :: 有效？
#
# == Indexes
#
# product_id
#
class Shop::Video < ActiveRecord::Base
	self.table_name = :shop_videos

	belongs_to :product

	scope :active, ->{where :active => true }

	# attr_accessor :mp4_attachment, :mp4_attachment_file_name, :mp4_attachment_content_type, :mp4_attachment_file_size, :mp4_attachment_updated_at
	# attr_accessor :flv_attachment, :flv_attachment_file_name, :flv_attachment_content_type, :flv_attachment_file_size, :flv_attachment_updated_at
	# attr_accessor :swf_attachment, :swf_attachment_file_name, :swf_attachment_content_type, :swf_attachment_file_size, :swf_attachment_updated_at
	# attr_accessor :hd_attachment, :hd_attachment_file_name, :hd_attachment_content_type, :hd_attachment_file_size, :hd_attachment_updated_at
  #
	# has_attached_file :mp4_attachment, :url => "/image/shop/video/:id_partition/mp4/:fullname"
	# has_attached_file :flv_attachment, :url => "/image/shop/video/:id_partition/flv/:fullname"
	# has_attached_file :swf_attachment, :url => "/image/shop/video/:id_partition/swf/:fullname"
	# has_attached_file :hd_attachment, :url => "/image/shop/video/:id_partition/hd/:fullname"
  #
	# validates_attachment_content_type :mp4_attachment, :content_type => ['video/mp4', 'application/octet-stream'], :message => '只支持mp4格式', :allow_nil => true
	# validates_attachment_content_type :flv_attachment, :content_type => ['video/x-flv', 'application/octet-stream' ], :message => '只支持flv格式', :allow_nil => true
	# validates_attachment_content_type :swf_attachment, :content_type => [ 'application/x-shockwave-flash' ], :message => '只支持swf格式', :allow_nil => true
	# validates_attachment_content_type :hd_attachment, :content_type => ['video/mp4', 'application/octet-stream'], :allow_nil => true

	def mp4=(file) #:nodoc: all
		self[:mp4] = file.respond_to?(:content_type) ? (self.mp4_attachment = file) && (self.new_record? ? nil : self.mp4_attachment.url(:original, false)) : file.blank? ? nil : file
	end

	def flv=(file) #:nodoc: all
		self[:flv] = file.respond_to?(:content_type) ? (self.flv_attachment = file) && (self.new_record? ? nil : self.flv_attachment.url(:original, false)) : file.blank? ? nil : file
	end

	def swf=(file) #:nodoc: all
		self[:swf] = file.respond_to?(:content_type) ? (self.swf_attachment = file) && (self.new_record? ? nil : self.swf_attachment.url(:original, false)) : file.blank? ? nil : file
	end

	def hd=(file) #:nodoc: all
		self[:hd] = file.respond_to?(:content_type) ? (self.hd_attachment = file) && (self.new_record? ? nil : self.hd_attachment.url(:original, false)) : file.blank? ? nil : file
	end

	after_create do |record|
		[
			record.mp4_attachment.file? && (record[:mp4] = record.mp4_attachment.url(:original, false)),
			record.flv_attachment.file? && (record[:flv] = record.flv_attachment.url(:original, false)),
			record.swf_attachment.file? && (record[:swf] = record.swf_attachment.url(:original, false)),
			record.hd_attachment.file? && (record[:hd] = record.hd_attachment.url(:original, false)),
		].inject{|a,b|a||b} && record.save
	end
end
