module ModelExtends
  module Commentable
    include ActionView::Helpers::TextHelper

    def self.included(base_class)
      base_class.has_many :comments, as: :commentable, class_name: 'Comment', :order => "created_at desc"
      base_class.after_destroy do
        Comment.destroy_all(commentable_id: self.id, commentable_type: self.class.base_class.name)
      end
    end
  end
end
