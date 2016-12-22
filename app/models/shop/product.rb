##
# = 商城 产品 表
#
# == Fields
#
# user_id :: 编辑ID
# label :: 标注
# prefix :: 前缀
# name :: 名称
# description :: 描述
# major_pic :: 主图片（1000x1000）
# model_pic :: 模特图片（1000x1000）
# detail_pic :: 详情图片（不限）
# pic :: 列表页图片（145x145）
# cart_pic :: 订单图片（80x80）
# fitting_pic :: 试衣间图片（不限）
# download_pic :: 下载图片（不限）
# spec_pic :: 尺寸说明图片（不限）
# measure_table :: 尺寸表格
# measure_description :: 尺寸描述
# measure_style :: 尺寸款型
# color_pic :: 颜色图片（35x35）
# color_name :: 颜色名称
# match_pic :: 搭配图片（200x370）
# match_product_ids :: 搭配产品ID列表，用英文逗号分隔
# identifier :: 编号
# keywords :: 关键字，用英文逗号分隔
# styles :: 款式，用英文逗号分隔
# brand_link :: 品牌链接
# brand_description :: 品牌描述
# material :: 材料
# accelerator :: 配件
# percent :: 最大折扣（0-20）
# point :: 积分
# zoom :: 缩放
# image_id :: 主图片ID
# video_id :: 主视频ID
# market_id :: 专场ID
# category_id :: 分类ID
# mall_id :: 商城ID
# category1_id :: 一级分类ID
# category2_id :: 二级分类ID
# category3_id :: 三级分类ID
# brand_id :: 品牌ID
# multibuy_id :: 连拍ID
# attribute_data :: 属性数据
# relate_product_ids :: 相关产品ID列表，用英文逗号分隔
# rec? :: 推荐？
# rec_pic :: 推荐图片
# target :: 对象，可以为%w[男 女 中性 儿童]之一
# thickness :: 厚度，可以为%w[薄 适中 厚 加厚]之一
# elasticity :: 弹力，可以为%w[无弹 微弹 中弹 强弹]之一
# pliability :: 柔软，可以为%w[柔软 适中 偏硬]之一
# recommend :: 推荐，可以为 { 'featured' => '精选', 'newest' => '最新', 'hot' => '热门' } 之一
# color :: \颜色，可以为%w[红 粉 紫 蓝 绿 黄 橙 棕 灰 黑 白 银 彩]之一
# order :: 排序
# price :: 市场价
# discount :: 销售价
# discount_history :: 销售价历史
# original_price :: 原始价
# minimum_price :: 最低价
# shop_price :: 店铺价
# sold_count :: 已售出数
# unsold_count :: 未售出数
# measures_unsold_count :: 各尺寸未售出数，JSON格式，例如{ 'XL': 1, 'XXL': 2 }
# scarcity :: \稀缺，可以为[0,20,40,60,80,100]
# readings_count :: 浏览数
# storage_location :: 仓库地点
# published? :: 发布？
# active? :: 有效？
#
# == Indexes
#
class Shop::Product < ActiveRecord::Base
  self.table_name = "shop_products"
  include EditorAttachable

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "user_id"
  belongs_to :mall
  belongs_to :category
  belongs_to :category1, :class_name => 'Category'
  belongs_to :category2, :class_name => 'Category'
  belongs_to :category3, :class_name => 'Category'
  belongs_to :brand
  belongs_to :multibuy
  belongs_to :market
  belongs_to :image
  belongs_to :video
  has_many :values, -> { where(active: true) }
  has_many :notifications, -> { where(active: true) }
  has_many :items, -> { where(active: true) }
  has_many :images, -> { where(active: true).order('COALESCE(sequence, 1000000) ASC, id ASC') }, :class_name => 'Shop::Image'
  # has_many :operation_images,->{where(active: true)},:class_name => "Shop::ProductOperationImage", order: 'COALESCE(sequence, 1000000) ASC, id ASC'
  has_many :videos, -> { where(active: true) }
  has_many :updatings, :class_name => 'ProductsUpdating'
  has_many :comments, -> { where(active: true).order "comments.id DESC" }, :as => :commentable

  accepts_nested_attributes_for :images, allow_destroy: true
  # accepts_nested_attributes_for :operation_images, :reject_if => Proc.new { |attributes| !attributes['id'] && attributes['active'] == '0' }
  # accepts_nested_attributes_for :videos

  mount_uploader :pic_image, ProductUploader, :mount_on => :pic
  mount_uploader :list_image, ProductUploader, :mount_on => :list_pic
  mount_uploader :cart_image, ProductUploader, :mount_on => :cart_pic
  mount_uploader :spec_image, ProductUploader, :mount_on => :spec_pic
  mount_uploader :color_image, ProductUploader, :mount_on => :color_pic
  mount_uploader :match_image, ProductUploader, :mount_on => :match_pic
  mount_uploader :major_image, ProductUploader, :mount_on => :major_pic

  # validates_attachment_content_type :list_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :cart_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :spec_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :color_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :match_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :major_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :fitting_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
  # validates_attachment_content_type :background_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :allow_nil => true
  # validates_attachment_content_type :extra_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :allow_nil => true
  # validates_attachment_content_type :model_pic_attachment, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :allow_nil => true
  # validates_attachment_content_type :detail_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :allow_nil => true
  # validates_attachment_content_type :download_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :allow_nil => true
  def self.xml_options_for(response = nil)
    case response
      when 'simple'
        simple_xml_options
      when 'summary'
        summary_xml_options
      else
        new_xml_options
    end
  end

  cattr_accessor :simple_xml_options
  self.simple_xml_options = {
      :only => [:id, :discount, :zoom, :updated_at].freeze,
  }.freeze

  cattr_accessor :summary_xml_options
  self.summary_xml_options = {
      :only => [:id, :label, :prefix, :name, :model_pic, :price, :discount, :minimum_price, :updated_at, :percent_text, :unsold_count, :measures_unsold_count, :color_name, :point, :brand_id, :mall_id, :zoom, :target, :category1_id, :multibuy_id].freeze,
      :methods => [:sell_current, :major_pic_url].freeze,
  }.freeze

  cattr_accessor :xml_options
  cattr_accessor :new_xml_options
  self.xml_options = self.new_xml_options = {
      :only => [:id, :label, :prefix, :name, :description, :price, :discount, :original_price, :minimum_price, :spec_pic, :fitting_pic, :color_pic, :color_name, :image_id, :percent_text, :video_id, :target, :thickness, :elasticity, :pliability, :recommend, :color, :match_pic, :major_pic, :model_pic, :unsold_count, :measures_unsold_count, :created_at, :updated_at, :point, :measure_table, :measure_style, :measure_description, :measure_suggestion, :zoom, :origins, :background, :extra_description, :extra_pic, :detail_pic, :download_pic, :shop_price].freeze,
      :include => {
          # :images => { :only => [ :id, :large, :description, :sequence ].freeze, :objects => {}.freeze, }.freeze,
          # :operation_images => { :only => [ :id, :pic, :sequence ].freeze, :objects => {}.freeze, }.freeze,
          # :videos => { :only => [ :id, :mp4, :flv, :swf, :hd, :description, :has_audio ].freeze, :objects => {}.freeze, }.freeze,
          # :mall => { :only => [ :id, :name].freeze, :objects => {}.freeze, }.freeze,
          :category1 => {:only => [:id, :name, :description, :measures, :ranges].freeze, :objects => {}.freeze, }.freeze,
          :category2 => {:only => [:id, :name, :description, :pic, :measures, :ranges, :measure_pic, :measure_properties, :bust_offset, :bust_error, :waistline_offset, :waistline_error, :hip_offset, :hip_error, :shoulder_offset, :shoulder_error, :arm_offset, :arm_error, :leg_offset, :leg_error, :contrast_pic].freeze, :objects => {}.freeze, }.freeze,
          :category3 => {:only => [:id, :name].freeze, :objects => {}.freeze, }.freeze,
          # :brand => {:only => [:id, :name, :chinese, :abbreviation, :initial, :link, :description, :pic, :swf, :recommend].freeze, :include => {:images => {:only => [:id, :pic, :sequence].freeze, :objects => {}.freeze, }.freeze}.freeze, :objects => {}.freeze, }.freeze,
          :brand => {:only => [:id, :name, :chinese, :abbreviation, :initial, :link, :description, :pic, :swf, :recommend]}.freeze,
          multibuy: {only: [:id, :name, :percent_for_2, :percent_for_3, :percent_for_4]},
          :values => {:only => [:id, :attribute_name, :content].freeze, :objects => {}.freeze, }.freeze,
      }.freeze,
      :objects => {
          :relate_products => {:only => [:id, :name, :color_name, :color_pic].freeze, :include => {}.freeze, :methods => {}.freeze, :objects => {}.freeze, }.freeze,
          :match_products => {:only => [:id, :name, :major_pic].freeze, :include => {}.freeze, :methods => {}.freeze, :objects => {}.freeze, }.freeze,
      }.freeze,
      :methods => [:sell_current].freeze,
  }.freeze

  COLORS = {'红' => 'red', '粉' => 'pink', '紫' => 'purple', '蓝' => 'blue', '绿' => 'green', '黄' => 'yellow', '橙' => 'orange', '棕' => 'brown', '灰' => 'gray', '黑' => 'black', '白' => 'white', '银' => 'silver', '彩' => 'multicolor'}
  RECOMMENDS = {'featured' => '精选', 'newest' => '最新', 'hot' => '热门'}
  TARGETS = %w[男 女 中性 无性别 儿童]
  THICKNESS = %w[薄 适中 厚 加厚]
  ELASTICITY = %w[无弹 微弹 中弹 强弹]
  PLIABILITY = %w[柔软 适中 偏硬]
  MEASURE_STYLES = [
      {name: 'standard-tops', title: '上装标准型', image: "/themes/purple/images/product/style/standard-tops.png"},
      {name: 'loose-tops', title: '上装宽松型', image: "/themes/purple/images/product/style/loose-tops.png"},
      {name: 'skinny-tops', title: '上装修身型', image: "/themes/purple/images/product/style/skinny-tops.png"},
      {name: 'standard-bottoms', title: '下装标准型', image: "/themes/purple/images/product/style/standard-bottoms.png"},
      {name: 'straight-bottoms', title: '下装直筒型', image: "/themes/purple/images/product/style/straight-bottoms.png"},
      {name: 'bell-bottoms', title: '下装喇叭型', image: "/themes/purple/images/product/style/bell-bottoms.png"},
      {name: 'tapered-bottoms', title: '下装锥型', image: "/themes/purple/images/product/style/tapered-bottoms.png"},
      {name: 'normal-shoes', title: '鞋-正常', image: "/themes/purple/images/product/style/normal-shoes.png"},
      {name: 'low-instep', title: '跗面偏低', image: "/themes/purple/images/product/style/low-instep.png"},
      {name: 'narrow-shoes', title: '鞋口偏窄', image: "/themes/purple/images/product/style/narrow-shoes.png"},
      {name: 'slim-shoes', title: '鞋型偏瘦', image: "/themes/purple/images/product/style/slim-shoes.png"},
      {name: 'tight-foreside', title: '鞋前部偏紧', image: "/themes/purple/images/product/style/tight-foreside.png"},
      {name: 'tight-middle', title: '鞋中部偏紧', image: "/themes/purple/images/product/style/tight-middle.png"},
      {name: 'tight-heel', title: '鞋后部偏紧', image: "/themes/purple/images/product/style/tight-heel.png"},
      {name: 'fat-shoes', title: '鞋型偏肥', image: "/themes/purple/images/product/style/fat-shoes.png"},
      {name: 'tight-bootleg', title: '靴筒偏紧', image: "/themes/purple/images/product/style/tight-bootleg.png"},
      {name: 'low-instep_narrow-shoes', title: '跗面偏低+鞋口偏窄', image: "/themes/purple/images/product/style/low-instep_narrow-shoes.png"},
      {name: 'low-instep_slim-shoes', title: '跗面偏低+鞋型偏瘦', image: "/themes/purple/images/product/style/low-instep_slim-shoes.png"},
      {name: 'low-instep_tight-foreside', title: '跗面偏低+鞋前部偏紧', image: "/themes/purple/images/product/style/low-instep_tight-foreside.png"},
      {name: 'low-instep_tight-middle', title: '跗面偏低+鞋中部偏紧', image: "/themes/purple/images/product/style/low-instep_tight-middle.png"},
      {name: 'low-instep_tight-heel', title: '跗面偏低+鞋后部偏紧', image: "/themes/purple/images/product/style/low-instep_tight-heel.png"},
      {name: 'low-instep_fat-shoes', title: '跗面偏低+鞋型偏肥', image: "/themes/purple/images/product/style/low-instep_fat-shoes.png"},
      {name: 'low-instep_tight-bootleg', title: '跗面偏低+靴筒偏紧', image: "/themes/purple/images/product/style/low-instep_tight-bootleg.png"},
      {name: 'narrow-shoes_slim-shoes', title: '鞋口偏窄+鞋型偏瘦', image: "/themes/purple/images/product/style/narrow-shoes_slim-shoes.png"},
      {name: 'narrow-shoes_foreside-tight', title: '鞋口偏窄+鞋前部偏紧', image: "/themes/purple/images/product/style/narrow-shoes_foreside-tight.png"},
      {name: 'narrow-shoes_tight-middle', title: '鞋口偏窄+鞋中部偏紧', image: "/themes/purple/images/product/style/narrow-shoes_tight-middle.png"},
      {name: 'narrow-shoes_tight-heel', title: '鞋口偏窄+鞋后部偏紧', image: "/themes/purple/images/product/style/narrow-shoes_tight-heel.png"},
      {name: 'narrow-shoes_fat-shoes', title: '鞋口偏窄+鞋型偏肥', image: "/themes/purple/images/product/style/narrow-shoes_fat-shoes.png"},
      {name: 'slim-shoes_tight-bootleg', title: '鞋型偏瘦+靴筒偏紧', image: "/themes/purple/images/product/style/slim-shoes_tight-bootleg.png"},
      {name: 'foreside-tight_tight-bootleg', title: '鞋前部偏紧+靴筒偏紧', image: "/themes/purple/images/product/style/foreside-tight_tight-bootleg.png"},
      {name: 'tight-middle_tight-bootleg', title: '鞋中部偏紧+靴筒偏紧', image: "/themes/purple/images/product/style/tight-middle_tight-bootleg.png"},
      {name: 'tight-heel_tight-bootleg', title: '鞋后部偏紧+靴筒偏紧', image: "/themes/purple/images/product/style/tight-heel_tight-bootleg.png"},
      {name: 'fat-shoes_tight-bootleg', title: '鞋型偏肥+靴筒偏紧', image: "/themes/purple/images/product/style/fat-shoes_tight-bootleg.png"},
      {name: 'low-instep_narrow-shoes_slim-shoes', title: '跗面偏低+鞋口偏窄+鞋型偏瘦', image: "/themes/purple/images/product/style/low-instep_narrow-shoes_slim-shoes.png"},
      {name: 'low-instep_slim-shoes_tight-bootleg', title: '跗面偏低+鞋型偏瘦+靴筒偏紧', image: "/themes/purple/images/product/style/low-instep_slim-shoes_tight-bootleg.png"},
      {name: 'low-instep_narrow-shoes_foreside-tight', title: '跗面偏低+鞋口偏窄+鞋前部偏紧', image: "/themes/purple/images/product/style/low-instep_narrow-shoes_foreside-tight.png"},
      {name: 'low-instep_foreside-tight_tight-bootleg', title: '跗面偏低+鞋前部偏紧+靴筒偏紧', image: "/themes/purple/images/product/style/low-instep_foreside-tight_tight-bootleg.png"},
  ]

  FIELDS = [
      {
          :name => nil,
          :title => "",
          :value => [
              {:name => "ID", :value => :id},
              {:name => "名称", :value => :name},
              {:name => "市场价", :value => :price},
              {:name => "销售价", :value => :discount},
          ],
      },
      {
          :name => "page",
          :title => "页面",
          :value => [
              {:name => "ID", :value => :id},
              {:name => "主图片", :value => lambda { |p| p.major_pic.blank? ? nil : "http://#{[::HOSTS['image']].flatten.first}#{p.major_pic}" }},
              {:name => "市场价", :value => :price},
              {:name => "销售价", :value => :discount},
              {:name => "品牌", :value => lambda { |p| p.brand && p.brand.name }},
              {:name => "名称（不包含品牌名称）", :value => lambda { |p| p.name.to_s.gsub(p.brand && p.brand.name || '', '') }},
              {:name => "地址", :value => lambda { |p| "http://#{::HOSTS['dynamic']}/#subapp=productGrid&category2_id=#{p.category2_id}&extid=#{p.id}#{"&target=#{CGI::escape(p.target)}" if %w[男 女].include?(p.target)}" }},
          ],
      }
  ]
  before_save do
    self.arrived_at ||= Time.now
    self.published_at ||= Time.now
  end

  def deletable? #:nodoc: all
    self.items.empty?
  end

  def major_pic_url
    self.major_image.url
  end

  def to_attachment #:nodoc: all
    {
        :name => self.name,
        :href => "/shop/products/#{self.id}",
        :description => self.description.to_s.scan(/./)[0, 200].join('') << "...",
        :object_id => self.id,
        :object_type => "product"
    }
  end

  def sync_sell_data! #:nodoc: all
    return unless self.active?
    self.items_count = self.items.count
    self.items_unpublished_count = self.items.unpublished.count
    self.items_unsold_count = self.items.published.unsold.count
    self.sold_count = self.items.published.sold.count
    self.unsold_count = self.items.published.unsold.select('DISTINCT measure').map.size
    self.measures_unsold_count = self.items.published.map { |i| i.measure = nil if i.measure.blank?; i }.group_by(&:measure).map { |g| {g[0] => (c = g[1].reject(&:trade_id).size) && c > 0 ? 1 : 0} }.inject({}, &:merge).to_json
    self.save! if self.changed?
  end

  def sell_current #:nodoc: all
    self.sold_count
  end

  def relate_products #:nodoc: all
    self.relate_product_ids.to_s.scan(/\d+/).map { |id| p = Shop::Product.find(id); p && p.active? && p.published? ? p : nil }.compact
  end

  def match_products #:nodoc: all
    self.match_product_ids.to_s.scan(/\d+/).map { |id| p = Shop::Product.find(id); p && p.active? && p.published? ? p : nil }.compact
  end

  def attributes_with_values #:nodoc: all
    selected_groups = self.values.active.group_by(&:attribute_id).map { |attribute_id, values| {values[0].attribute_obj => values} }.inject({}, &:merge)
    selected_groups.reject! { |item| item.nil? }
    unselected_groups = ((self.category2 && self.category2.inheritance_attributes || []) - selected_groups.keys).map { |a| {a => []} }.inject({}, &:merge)
    [selected_groups, unselected_groups].inject({}, &:merge)
  end


  def basic_values
    basic_groups=self.category2 && self.category2.inheritance_basic_attributes
    self.values.select { |value| basic_groups.map(&:id).include?(value.attribute_id) }
    # self.attributes_with_values
  end

  def market_price #:nodoc: all
    price
  end

  def market_price=(value) #:nodoc: all
    price = vlaue
  end

  def selling_price #:nodoc: all
    discount
  end

  def selling_price=(value) #:nodoc: all
    discount = value
  end

  def selling_price_with_hourglass #:nodoc: all
    p = selling_price - (Time.now - hourglass_started_at - (hourglass_pause_duration || 0).minutes) / 1.minute * hourglass_rate
    p = 0 if p < 0
    p = selling_price if p > selling_price
    p
  end


  def percent_text #:nodoc: all
    d = self.discount; p = self.price
    d && p && p > d ? (d*10/p).to_s + ((d*100/p)%10 == 0 ? "" : ".#{(d*100/p)%10}") : nil
  end

  def weighted_products #:nodoc: all
    self.class.active.published.where(["unsold_count > 0 AND target = ? AND id <> ?", self.target, self.id]).select("((category1_id = #{self.category1_id || 0})*0.2 + (category2_id = #{self.category2_id || 0})*0.2 + (brand_id = #{self.brand_id || 0})*0.3 + (color = #{self.class.connection.quote(self.color)})*0.1 + (1 - IF(discount >= #{self.discount || 0}, #{self.discount || 0}/(discount+0.01), discount/(#{self.discount || 0}+0.01)))*0.2) AS weight, #{self.class.quoted_table_name}.*").order("weight DESC")
  end

  def sync!(user=nil) #:nodoc: all
    erp_crstorage = ErpRecord.connection.select_all("SELECT sku,brand_id,market_price,goods_price,original_sale_price,low_price,cat_id,sn,sizeer_name,size_name,goods_name,status,transfer_type, product_target,selling_points,old_style_no,intype_id,cr_time,validity, storage_name, made_in, store_num, cost_price, surcharge_price, tariff_price, pid FROM erp_crstorage WHERE sku = #{self.id}")
    erp_skuprice = ErpRecord.connection.select_all("SELECT goods_price, market_price, original_sale_price, low_price FROM erp_skuprice_change_logs WHERE sku = #{self.id} ORDER BY log_id DESC").first
    if erp_skuprice
      self.price = erp_skuprice['market_price']
      self.discount = erp_skuprice['goods_price']
      self.shop_price = if self.discount.to_i < 10
                          self.discount
                        else
                          (self.discount/0.9).round(-1) >= self.price ? self.discount : (self.discount/0.9).round(-1)
                        end
      self.original_price = erp_skuprice['original_sale_price']
      self.minimum_price = erp_skuprice['low_price']
      self.save!
    end
    return if erp_crstorage.length < 1
    if (crstorage = erp_crstorage.reject { |ec| ec["transfer_type"] == 'OUT' || ec["status"] == 'DETROY' || ec["status"] == 'RET' || ec["status"] == 'DELIVER' || ec["status"] == 'OUT' || ec["status"] == 'DAMAGE' }) && !crstorage.blank?
      crstorage = crstorage.first.symbolize_keys
      self.user_id ||= user && user.id
      self.name ||= crstorage[:goods_name]
      self.prefix ||= crstorage[:selling_points]
      self.target ||= crstorage[:product_target]
      self.identifier ||= crstorage[:old_style_no]
      self.brand_id ||= crstorage[:brand_id] && (brand = ErpRecord.connection.select_all("SELECT old_id FROM erp_brand WHERE brand_id = #{crstorage[:brand_id]}").first) && brand['old_id']
      if crstorage[:cat_id] && (erp_cat = ErpRecord.connection.select_all("SELECT old_id, old_parent_id FROM `erp_cat` WHERE id = '#{crstorage[:cat_id]}'").first)
        self.category1_id ||= erp_cat && erp_cat['old_parent_id']
        self.category2_id ||= erp_cat && erp_cat['old_id']
      end
      self.storage_location = crstorage[:storage_name].to_s[/北京|天津|香港/]
      self.origins = (origins = erp_crstorage.reject { |ec| ec["transfer_type"] == 'OUT' || ec["status"] == 'DETROY' || ec["status"] == 'RET' || ec["status"] == 'DELIVER' }.map { |c| c['made_in'] }.uniq) && origins.map(&:blank?).inject(&:|) ? nil : origins.join("\n") rescue nil
      self.active = true
      self.save!
    end

    erp_crstorage.each do |ec|
      ec = ec.symbolize_keys
      item = Item.find_or_initialize_by_identifer(ec[:sn])
      next unless item.deletable?
      item.product_id = self.id
      item.user_id ||= user && user.id
      # item.published = true
      item.purchase_type = ec[:intype_id]
      item.origin = ec[:made_in]
      item.storage_name = ec[:storage_name]
      item.store_num = ec[:store_num]
      item.barcode = ec[:pid].to_s[0..11]
      item.storage_at = Time.at ec[:cr_time].to_s.to_i if ec[:cr_time] && !ec[:cr_time].to_s.to_i.zero?
      item.expired_at = Time.at(ec[:validity].to_s.to_i) if ec[:validity] && !ec[:validity].to_s.to_i.zero?
      item.active = ec[:transfer_type] != 'OUT' && ec[:status] != 'DETROY' && ec[:status] != 'RET' && ec[:status] != 'DELIVER' && ec["status"] != 'DAMAGE'
      item.original_measure = ec[:sizeer_name].to_s + ec[:size_name].to_s
      item.cost_price = ec[:cost_price] + ec[:surcharge_price] + ec[:tariff_price]
      item.save!
    end
    self.sync_sell_data!
  end

  after_create do |record|
    # [
    # 	record.list_image.file? && (record[:pic] = record.list_image.url(:original, false)),
    # 	record.cart_image.file? && (record[:cart_pic] = record.cart_image.url(:original, false)),
    # 	record.spec_image.file? && (record[:spec_pic] = record.spec_image.url(:original, false)),
    # 	record.color_image.file? && (record[:color_pic] = record.color_image.url(:original, false)),
    # 	record.match_image.file? && (record[:match_pic] = record.match_image.url(:original, false)),
    # 	record.major_image.file? && (record[:major_pic] = record.major_image.url(:original, false)),
    # 	record.fitting_image.file? && (record[:fitting_pic] = record.fitting_image.url(:original, false)),
    # 	record.background_image.file? && (record[:background] = record.background_image.url(:original, false)),
    # 	record.extra_image.file? && (record[:extra_pic] = record.extra_image.url(:original, false)),
    # 	record.model_pic_attachment.file? && (record[:model_pic] = record.model_pic_attachment.url(:original, false)),
    # 	record.detail_image.file? && (record[:detail_pic] = record.detail_image.url(:original, false)),
    # 	record.download_image.file? && (record[:download_pic] = record.download_image.url(:original, false)),
    # ].inject{|a,b|a||b} && record.save
  end

  after_save do |record|
    Shop::Product.clear_product_caches(record['id'])
    #
    # (
    # 	# set first image/video to default if not specified by editor
    # 	!record.image && (i = record.images.scoped(:order => 'id ASC').first) && (record.image_id = i.id) ||
    # 	!record.video && (i = record.videos.scoped(:order => 'id ASC').first) && (record.video_id = i.id)
    # ) && record.save
  end

  def valid_alert_messages
    product = self
    [
        {:valid => !product.name.blank?, :message => "未填写标题", },
        {:valid => !product.description.blank?, :message => "未填写描述", },
        {:valid => product.price, :message => "未填写市场价", },
        {:valid => product.discount, :message => "未填写销售价", },
        {:valid => !product.price || !product.discount || (product.price >= product.discount) && (product.discount >= 0), :message => "价格大小不正确", },
        # {:valid => product.mall, :message => "未选择商城", },
        {:valid => product.brand, :message => "未选择品牌", },
        {:valid => product.category1, :message => "未选择一级分类", },
        {:valid => product.category2, :message => "未选择二级分类", },
        {:valid => (product.category2 && product.category2.parent) == product.category1, :message => "两级分类不一致", },
        {:valid => product.target, :message => "未选择对象", },
        {:valid => product.color, :message => "未选择颜色", },
        {:valid => !product.color_name.blank?, :message => "未填写颜色名称", },
        {:valid => product.color_pic, :message => "未上传颜色图片", },
        {:valid => product.major_pic, :message => "未上传主图片", },
        {:valid => product.image, :message => "未上传封面图片", },
        {:valid => product.images.map { |i| !i.large.blank? }.inject(&:&), :message => "未上传详细图片", },
        {:valid => product.items.active.unpublished.count == 0, :message => "未发布所有单件", },
    ]
  end

  class<<self
    def active
      where(active: true)
    end

    def xml_options
      {:only => [:id, :name, :parent_id, :measures, :ranges, :male, :female, :order]}
    end

    def published
      where(published: true)
    end

    def order_desc
      order("order desc")
    end

    def clear_product_caches(obj)
      id = obj.try(:id) || obj
      ['', '.xml', '.json', '/response_summary.xml', '/response_summary.json'].each do |fmt|
        Rails.cache.delete("views//shop/products/#{id}#{fmt}") rescue nil
        Rails.cache.delete("views//mobile/products/#{id}#{fmt}") rescue nil
      end
    end
  end
end
