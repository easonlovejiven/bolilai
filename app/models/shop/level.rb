##
# = 商城 等级 表
#
# == Fields
#
# editor_id :: 编辑ID
# icon :: 图标
# name :: 名称
# description :: 描述
# limitation :: 限额
# percent :: 折扣
# mall_ids :: 商城ID列表
# active? :: 有效？
#
# == Indexes
#
class Shop::Level < ActiveRecord::Base
  self.table_name = :shop_levels

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
  has_many :users,class_name: "Shop::User"

  scope :active, -> { where active: true }

  attr_accessor :icon_upload, :icon_upload_file_name, :icon_upload_content_type, :icon_upload_file_size, :icon_upload_updated_at
  # has_attached_file :icon_upload, :url => "/image/auction/level/:id_partition/icon/:fullname", :processors => [:thumbnail, :paperclip_optimizer]
  # validates_attachment_content_type :icon_upload, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持JPEG、PNG、GIF格式的图片', :allow_nil => true
  mount_uploader :icon_image, PhotoUploader, :mount_on => :icon

  self.xml_options = {
      :only => [:id, :icon, :name, :description, :limitation, :reservation, :percent,].freeze,
      :objects => {
          :malls => {
              :only => [:id, :pic, :rule, :detail, :genre, :name, :description, :percent,].freeze,
          }.freeze,
      }.freeze,
  }.freeze

  def malls #:nodoc: all
    self.mall_ids.to_s.scan(/\d+/).map { |id| Mall.active.find_by_id(id) }.compact
  end

  def icon=(file) #:nodoc: all
    self[:icon] = file.respond_to?(:content_type) ? (self.icon_upload = file) && (self.new_record? ? nil : self.icon_upload.url(:original, false)) : file.blank? ? nil : file
  end

  # after_create do |record|
  # 	[
  # 		record.icon_upload.file? && (record[:icon] = record.icon_upload.url(:original, false)),
  # 	].inject{|a,b|a||b} && record.save
  # end
end
