class Data::Province < ActiveRecord::Base #:nodoc: all
	self.table_name= :data_provinces

	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "user_id"
	belongs_to :country
	has_many :cities

	scope :active, ->{ where :active => true }
  scope :published, ->{ where  :published => true }
end
