##
# = 商城 页面
#
# == Fields
#
# name :: 名称
# series :: 系列
# position :: 位置
# title :: 标题
# keywords :: 关键字
# description :: 描述
# engine :: 引擎
# content :: 内容
# editor_id :: 编辑
# published? :: 发布
# active? :: 有效
#
# == Indexes
#
class CustomPage::Page < ActiveRecord::Base
  self.table_name = "custom_page_pages"
	belongs_to :editor, :class_name => "Manage::Editor"
	has_many :images,->{where({ :active => true })}, :class_name => "CustomPage::Image"
	has_many :pages_pages, ->{where({ :active => true }).order("id ASC")},:class_name=>"CustomPage::PagesPage"
	has_many :pages,->{where({ :active => true })}, :through => :pages_pages, :source => :child

	accepts_nested_attributes_for :images, :reject_if => Proc.new { |attributes| !attributes['id'] && attributes['active'] == '0' }
	accepts_nested_attributes_for :pages_pages, :reject_if => Proc.new { |attributes| !attributes['id'] && attributes['active'] == '0' }

	validates_associated :images
	validates_associated :pages_pages

	scope :active,->{where({:active => true })}
  scope :published, ->{where({ :published => true })}

	POSITIONS = [
		{ :value => 'root', :name => '首页' },
		{ :value => 'mobile_root', :name => '移动端首页' },
		{ :value => 'brands', :name => '品牌列表' },
		{ :value => 'store', :name => '旗舰店' },
		{ :value => 'cs_problems', :name => '客服问答' },
		{ value: 'background', name: '背景' }
	]
	ENGINES = %w[template haml slim]

	validates_inclusion_of :position, :in => POSITIONS.map { |position| position[:value] }, :allow_blank => true
	validates_inclusion_of :engine, :in => ENGINES, :allow_blank => true

	cattr_accessor :manage_fields
	self.manage_fields = %w[name series position title keywords description engine content snapshot images_attributes pages_pages_attributes]

	# attr_accessor :snapshot_attachment, :snapshot_attachment_file_name, :snapshot_attachment_content_type, :snapshot_attachment_file_size, :snapshot_attachment_updated_at
	# has_attached_file :snapshot_attachment, :url => "/image/auction/page/:id_partition/snapshot/:fullname"
	# validates_attachment_content_type :snapshot_attachment, :content_type => %w[image/jpeg image/jpg image/pjpeg image/png image/x-png image/gif], :allow_nil => true
  mount_uploader :snapshot_image, PhotoUploader, :mount_on => :snapshot

	def to_data
		(JSON.parse(self.content.to_s) rescue {}).merge('pages' => self.pages_pages.order('id ASC').include(:child).map(&:child).map(&:to_data))
  end

	def deletable?
    CustomPage::PagesPage.active.where({ :child_id => self.id }).joins("JOIN custom_page_pages ON custom_page_pages.id = custom_page_pages_pages.page_id AND custom_page_pages.active = TRUE").empty?
	end

	def self.search id_or_position
		self.active.published.where({ (id_or_position.to_s.match(/^\d+$/) ? :id : :position) => id_or_position}).order('id DESC').first
	end
end
