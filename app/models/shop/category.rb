##
# = 商城 分类 表
#
# == Fields
#
# user_id :: 编辑ID
# parent_id :: 父类ID
# name :: 名称
# description :: 描述
# pic :: 图片
# measures :: 尺码列表，用英文逗号分隔
# ranges :: 价格区间，用英文逗号分隔
# male? :: 男士？
# female? :: 女士？
# attribute_ids :: 属性ID列表，用英文逗号分隔
# order :: 顺序
# measure_properties :: 尺寸参数
# measure_pic :: 尺寸图片
# contrast_pic :: 对照图片
# bust_offset :: 胸围偏移
# bust_error :: 胸围误差
# waistline_offset :: 腰围偏移
# waistline_error :: 腰围误差
# hip_offset :: 臀围偏移
# hip_error :: 臀围误差
# shoulder_offset :: 肩宽偏移
# shoulder_error :: 肩宽误差
# arm_offset :: 臂长偏移
# arm_error :: 臂长误差
# leg_offset :: 腿长偏移
# leg_error :: 腿长误差
# published? :: 发布？
# active? :: 有效？
#
# == Indexes
#
module Shop
  class Category < ActiveRecord::Base
    self.table_name = "shop_categories"
    # acts_as_nested_set

    belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "user_id"
    belongs_to :parent, -> { where(:active => true) }, :foreign_key => :parent_id, :class_name => 'Shop::Category'
    has_many :children, -> { where(:active => true) }, :foreign_key => :parent_id, :class_name => 'Shop::Category'
    has_many :products, -> { where(:active => true) }, :foreign_key => :category2_id


    attr_accessor :measure_image, :measure_image_file_name, :measure_image_content_type, :measure_image_file_size, :measure_image_updated_at
    attr_accessor :contrast_image, :contrast_image_file_name, :contrast_image_content_type, :contrast_image_file_size, :contrast_image_updated_at
    # has_attached_file :measure_image, :url => "/image/auction/category/:id_partition/measure_pic/:fullname"
    # has_attached_file :contrast_image, :url => "/image/auction/category/:id_partition/contrast_pic/:fullname"
    # validates_attachment_content_type :measure_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
    # validates_attachment_content_type :contrast_image, :content_type => ['image/pjpeg', 'image/jpeg', 'image/jpg', 'image/gif', 'image/png', 'image/x-png'], :message => '只支持jpeg、jpg、gif、png图片格式', :allow_nil => true
    # has_attached_file_with_patch :pic, url: '/image/auction/category/:id_partition/pic/:updated_at.:extension:style_extension', styles: { :'256' => '256x256#', :'128' => '128x128#', :'64' => '64x64#' }
    # validates_attachment_with_patch :pic, content_type: { content_type: %w[image/jpeg image/jpg image/pjpeg image/png image/x-png image/gif] }, image_width: { equal_to: 1000 }, image_height: { equal_to: 1000 }
    mount_uploader :pic_image, PhotoUploader, :mount_on => :pic
    mount_uploader :banner_image, PhotoUploader, :mount_on => :banner_pic

    MEASURE_PROPERTIES = {
      'bust' => '胸围',
      'waistline' => '腰围',
      'hip' => '臀围',
      'shoulder' => '肩宽',
      'arm' => '袖长',
      'leg' => '裤长'
    }

    PRIORITIES = [
      {:name => "storage_at_asc", :title => "入库时间（默认）", :order => "storage_at ASC"},
      {:name => "expired_at_asc", :title => "过期时间", :order => "expired_at ASC"},
      {:name => "purchase_type_asc_and_storage_at_asc", :title => "采购类型和入库时间", :order => "purchase_type ASC, storage_at ASC"},
      {:name => "purchase_type_asc_and_storage_at_asc_and_cost_price_asc", :title => "采购类型和入库时间和成本价", :order => "purchase_type ASC, IF(purchase_type=5, storage_at, cost_price) ASC"},
      {:name => "random", :title => "随机", :order => "RAND()"},
    ]

    before_save do
      if self.attribute_ids_changed? && !self.attribute_ids.blank?
        write_attribute(:attribute_ids,JSON.parse(self.attribute_ids).join(","))
      end
      if self.basic_attribute_ids_changed? && !self.basic_attribute_ids.blank?
        write_attribute(:basic_attribute_ids,JSON.parse(self.basic_attribute_ids).join(","))
      end
    end

    def deletable? #:nodoc: all
      !self.root? && self.children.empty? && self.products.empty?
    end

    def parents #:nodoc: all
      parents = []
      p = self
      parents << p while (p = p.parent) && !parents.include?(p)
      parents
    end

    def self_and_parents
      [self].concat(parents)
    end

    def current_attributes #:nodoc: all
      self.attribute_ids.to_s.split(',').map { |id| Shop::Attribute.find(id) }
    end

    def basic_attributes
      self.basic_attribute_ids.to_s.split(',').map { |id| Shop::Attribute.find(id) }
    end

    def inheritance_attributes #:nodoc: all
      (self.parents << self).map(&:current_attributes).flatten.compact.uniq
    end

    def inheritance_basic_attributes
      (self.parents << self).map(&:basic_attributes).flatten.compact.uniq
    end


    def measure_pic=(file) #:nodoc: all
      self[:measure_pic] = file.respond_to?(:content_type) ? (self.measure_image = file) && (self.new_record? ? nil : self.measure_image.url(:original, false)) : file.blank? ? nil : file
    end

    def contrast_pic=(file) #:nodoc: all
      self[:contrast_pic] = file.respond_to?(:content_type) ? (self.contrast_image = file) && (self.new_record? ? nil : self.contrast_image.url(:original, false)) : file.blank? ? nil : file
    end

    def root?
      self.id==1
    end

    def current_banner_cate
     self.self_and_parents.detect{|item|!item.banner_image.blank?}
    end

    after_create do |record|
      # [
      #   record.measure_image.file? && (record[:measure_pic] = record.measure_image.url(:original, false)),
      #   record.contrast_image.file? && (record[:contrast_pic] = record.contrast_image.url(:original, false)),
      # ].inject { |a, b| a||b } && record.save
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
    end
  end
end
