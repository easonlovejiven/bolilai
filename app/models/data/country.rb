class Data::Country < ActiveRecord::Base #:nodoc: all
  self.table_name= :data_countries

  belongs_to :editor, :class_name => "Manage::Editor", :foreign_key => "user_id"
  has_many :provinces

  class<<self
    def active
      where({:active => true})
    end

    def published
      where({:published => true})
    end
  end
end
