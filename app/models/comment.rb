class Comment < ActiveRecord::Base

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  belongs_to :user,class_name: "Shop::User"
  belongs_to :commentable, polymorphic: true, :touch => true
  has_many :comment_images, -> { where(active: true).order('id ASC') }, foreign_key: 'comment_id'

  accepts_nested_attributes_for :comment_images, allow_destroy: true

  validates :body, :user_id, presence: true

  before_save do
    self.title ||= '评论'
  end

  scope :find_comments_by_user, lambda { |user| where(:user_id => user.id).order('created_at DESC') }
  scope :find_comments_for_commentable, lambda { |commentable| where(:commentable_type => commentable.class.name,
                                                                     :commentable_id => commentable.id).order('created_at DESC') }
  class << self
    def build_from(commentable, editor_id, comment_params, parent_id=nil)
      new(comment_params) do |cm|
        cm.commentable = commentable
        cm.editor_id = editor_id
        cm.parent_id = parent_id if parent_id.present?
      end
    end

    def is_active
      where(active: true)
    end

    def common_includes
      self.includes(:user, :parent, :commentable)
    end
  end

  def has_children?
    self.children.any?
  end

  def send_notice
    commentable = self.commentable
    commentable_user = commentable.user
    comment_user = self.user
    return if commentable_user == comment_user

    parameters={
        inviter_id: comment_user.id,
        inviter_name: comment_user.name
    }
  end

  def user_info
    user = self.user
    "#{user.name[0]}** · #{user.label}"
  end

end
