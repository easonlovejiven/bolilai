class CommentImage < ActiveRecord::Base
  belongs_to :comment
  mount_uploader :pic_image, PhotoUploader, :mount_on => :pic
end
