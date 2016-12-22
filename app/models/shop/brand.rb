##
# = 商城 品牌 表
#
# == Fields
#
# editor_id :: 编辑ID
# name :: 英文名
# chinese :: 中文名
# abbreviation :: 缩写
# initial :: 首字母
# genre :: 类型
# pic :: 图片（130x90）
# material :: 材质（190x100）
# swf :: swf文件
# link :: 圣经链接
# shop_link :: 旗舰店链接
# title :: 标题
# summary :: 概要
# description :: 描述
# pronunciation :: 发音
# country_id :: 国家ID
# year :: 年份
# keywords :: 关键字，用英文逗号分隔
# special_product_ids :: 特殊产品ID列表，用英文逗号分隔
# order :: 排序
# recommend :: 推荐，可以为 { 'featured' => '精选', 'newest' => '最新', 'hot' => '热门' } 之一
# introduced? :: 介绍？
# published? :: 发布？
# active? :: 有效？
#
# == Indexes
#
# name
#
class Shop::Brand < ActiveRecord::Base
	self.table_name= :shop_brands

	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "editor_id"
	belongs_to :country
	has_many :products
	# has_many :images, :class_name => "Shop::BrandImage", :conditions => { :active => true }, order: 'COALESCE(sequence, 1000000) ASC, id ASC'

	# accepts_nested_attributes_for :images, :reject_if => Proc.new { |attributes| !attributes['id'] && attributes['active'] == '0' }

  mount_uploader :pic_image, ProductUploader, :mount_on => :pic


  RECOMMEND_OPTIONS = { 'featured' => '精选', 'newest' => '最新', 'hot' => '热门' }

	# attr_accessor :pic_attachment, :pic_attachment_file_name, :pic_attachment_content_type, :pic_attachment_file_size, :pic_attachment_updated_at
	# attr_accessor :swf_attachment, :swf_attachment_file_name, :swf_attachment_content_type, :swf_attachment_file_size, :swf_attachment_updated_at
	# attr_accessor :swf2_attachment, :swf2_attachment_file_name, :swf2_attachment_content_type, :swf2_attachment_file_size, :swf2_attachment_updated_at
	# attr_accessor :pronunciation_attachment, :pronunciation_attachment_file_name, :pronunciation_attachment_content_type, :pronunciation_attachment_file_size, :pronunciation_attachment_updated_at
	# attr_accessor :material_attachment, :material_attachment_file_name, :material_attachment_content_type, :material_attachment_file_size, :material_attachment_updated_at

	# has_attached_file :pic_attachment, :url => "/image/shop/brand/:id_partition/pic/:fullname"
	# has_attached_file :swf_attachment, :url => "/image/shop/brand/:id_partition/swf/:fullname"
	# has_attached_file :swf2_attachment, :url => "/image/shop/brand/:id_partition/swf2/:fullname"
	# has_attached_file :pronunciation_attachment, :url => "/image/shop/brand/:id_partition/pronunciation/:fullname"
	# has_attached_file :material_attachment, :url => "/image/shop/brand/:id_partition/material/:fullname"
  #
	# validates_attachment_content_type :pic_attachment, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
	# validates_attachment_content_type :swf_attachment, :content_type => [ 'application/x-shockwave-flash' ], :message => '只支持swf格式', :allow_nil => true
	# validates_attachment_content_type :swf2_attachment, :content_type => [ 'application/x-shockwave-flash' ], :message => '只支持swf格式', :allow_nil => true
	# validates_attachment_content_type :pronunciation_attachment, :content_type => ['audio/mpeg', 'audio/mp3'], :message => '只支持MP3音频格式', :allow_nil => true
	# validates_attachment_content_type :material_attachment, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true

	INITIAL = ('A'..'Z').to_a
	validates :initial, inclusion: { in: INITIAL, allow_blank: true }

	# def pic=(file) #:nodoc: all
	# 	self[:pic] = file.respond_to?(:content_type) ? (self.pic_attachment = file) && (self.new_record? ? nil : self.pic_attachment.url(:original, false)) : file.blank? ? nil : file
	# end
  #
	# def swf=(file) #:nodoc: all
	# 	self[:swf] = file.respond_to?(:content_type) ? (self.swf_attachment = file) && (self.new_record? ? nil : self.swf_attachment.url(:original, false)) : file.blank? ? nil : file
	# end
  #
	# def swf2=(file) #:nodoc: all
	# 	self[:swf2] = file.respond_to?(:content_type) ? (self.swf2_attachment = file) && (self.new_record? ? nil : self.swf2_attachment.url(:original, false)) : file.blank? ? nil : file
	# end

	# def pronunciation=(file) #:nodoc: all
	# 	self[:pronunciation] = file.respond_to?(:content_type) ? (self.pronunciation_attachment = file) && (self.new_record? ? nil : self.pronunciation_attachment.url(:original, false)) : file.blank? ? nil : file
	# end
  #
	# def material=(file) #:nodoc: all
	# 	self[:material] = file.respond_to?(:content_type) ? (self.material_attachment = file) && (self.new_record? ? nil : self.material_attachment.url(:original, false)) : file.blank? ? nil : file
	# end

	after_create do |record|
		# [
		# 	record.pic_attachment.file? && (record[:pic] = record.pic_attachment.url(:original, false)),
		# 	record.swf_attachment.file? && (record[:swf] = record.swf_attachment.url(:original, false)),
		# 	record.swf2_attachment.file? && (record[:swf2] = record.swf2_attachment.url(:original, false)),
		# 	record.pronunciation_attachment.file? && (record[:pronunciation] = record.pronunciation_attachment.url(:original, false)),
		# 	record.material_attachment.file? && (record[:material] = record.material_attachment.url(:original, false)),
		# ].inject{|a,b| a||b} && record.save
	end


	cattr_accessor :complete_xml_options
	self.complete_xml_options = {
		:only => [ :id, :name, :chinese, :initial, :genre, :pic, :link, :shop_link, :title, :description, :pronunciation, :year, :keywords, :recommend, :order, :introduced, :material, :summary, :special_product_ids ].freeze,
		:include => {
			:country => { :only => [:id, :name].freeze, :include => {}, :objects => {} }.freeze,
		}.freeze,
		:objects => {
			:special_products => { :only => [:id, :updated_at].freeze, :include => {}.freeze, }.freeze,
		}.freeze,
	}.freeze

	def deletable? #:nodoc: all
		self.products.active.empty?
	end

	def self.top #:nodoc: all
		Shop::Brand.scoped(
			:select => "#{Shop::Brand.table_name}.*, COUNT(*) AS cnt",
			:joins => "JOIN #{Shop::Product.table_name} ON #{Shop::Brand.table_name}.id=#{Shop::Product.table_name}.brand_id AND #{Shop::Product.table_name}.unsold_count != 0",
			:group => "#{Shop::Product.table_name}.brand_id",
			:order => "cnt DESC",
			:limit => 15
		)
	end

	def self.top_male #:nodoc: all
		self.top.scoped(:conditions => ["target = ? OR target = ?", "男", "中性"])
	end

	def self.top_female #:nodoc: all
		self.top.scoped(:conditions => ["target = ? OR target = ?", "女", "中性"])
	end

	def special_products #:nodoc: all
		self.special_product_ids.to_s.split(',').map{|id| ((p = Shop::Product.find_by_id(id)) && p.active? && p.published?) ? p : nil }.compact
  end

  class<<self
    def   xml_options
      { :only => [ :id, :name, :chinese, :initial, :genre, :pic, :recommend, :order, :introduced, :material, :summary, :special_product_ids ].freeze }.freeze
    end

    def active
      where({active: true})
    end

    def published
      where({published: true})
    end
  end
end
