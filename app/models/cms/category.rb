class Cms::Category < ActiveRecord::Base
  self.table_name="cms_categories"
  acts_as_nested_set
  TEMPLATE_TYPE = {'default' => '帮助样式(1级或2级栏目样式)', 'list' => '文章列表（1级栏目样式）', 'show' => '全页面'}
  has_many :pages, -> { active }
  include EditorAttachable

  # belongs_to :parent,:class_name=>"Category"
  #  scope :root,where(:parent_id=>nil).limit("1")
  scope :sort, -> { order('created_at desc') }
  scope :active, -> { where(active: true) }
  scope :published, -> { where(published: true) }

  after_save do
    self.update_column("url","/cms/categories/#{self.id}") if self.url.blank?
  end

  def deletable?
    true
  end
  # def self.top_categories
  #   Category.where('parent_id'=>root.id)
  # end
  #
  # def self.root
  #   Category.where(:parent_id=>nil).first
  # end
  #
  #
  # #  scope siblings,where({:parent_id=>self.parent_id})
  # def siblings
  #   Category.find(:all, :conditions=>{:parent_id=>self.parent_id}).reject{|tax|tax.id==self.id}
  # end
  #
  # def siblings_and_self
  #   Category.where(:parent_id=>self.parent_id)
  # end
  #
  # def parents(attr=[])
  #   p=self.parent
  #   if p
  #     attr.push(p)
  #     p.parents(attr)
  #   else
  #     return attr.reverse
  #   end
  # end
  #
  # def parents_and_self
  #   parents.push(self)
  # end
  #
  # def parents_without_root
  #   p=parents_and_self
  #   p.shift
  #   p
  # end

end
