class Comment < ActiveRecord::Base
  default_scope -> { order('created_at') }

  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  validates :user, presence: true
  validates :content,
            presence: true,
            length: { :maximum => 10240 }

  def last?
    self.commentable.comments.last == self
  end

  def can_be_destroyed_by?(user)
    !user.nil? && (user.admin? || (self.user == user && last?))
  end
end
