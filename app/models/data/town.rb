class Data::Town < ActiveRecord::Base #:nodoc: all
  self.table_name= :data_towns

	belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "user_id"
	belongs_to :city

  scope :active, ->{ where :active => true }
  scope :published, ->{ where  :published => true }
end
