class Upload < ActiveRecord::Base
  belongs_to :user, :class_name => "Core::User", :foreign_key => "user_id"
  mount_uploader :pic, PhotoUploader, :mount_on => :file_key

  self.xml_options = {:only => [:id, :file_key, :file_name, :file_type]}

  def self.images
    where(file_type: ['image/jpeg', 'image/png', "image/jpeg", "image/gif", "image/bmp"])
  end

  def deletable?
    true
  end
end
