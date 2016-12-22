class Cms::Page < ActiveRecord::Base
  self.table_name = 'cms_pages'
  TEMPLATE_TYPE = {'full_page' => '全页面', 'side_page' => '内容页面'}
  include EditorAttachable
  acts_as_taggable
  belongs_to :editor, :class_name => 'Manage::Editor'
  belongs_to :category, :class_name => 'Cms::Category', foreign_key: 'category_id'

  scope :sort, -> { order('created_at') }
  scope :active, -> { where(active: true) }
  scope :published, -> { where(published: true) }

  before_save do
    self.template_type = 'side_page'
  end

  def deletable?
    true
  end

end
