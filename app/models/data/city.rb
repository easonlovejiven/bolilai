class Data::City < ActiveRecord::Base #:nodoc: all
  self.table_name= :data_cities

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "user_id"
  belongs_to :province
  has_many :towns

  scope :active, -> { where :active => true }
  scope :published, -> { where :published => true }
end
