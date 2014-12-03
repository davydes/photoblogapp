class Comment < ActiveRecord::Base
  default_scope -> { order('created_at') }

  belongs_to :user
  belongs_to :commentable, :polymorphic => true

  validates :user, presence: true
  validates :content,
            presence: true,
            length: { :maximum => 10240 }

  after_create :create_activities
  after_destroy :destroy_activities

  def owner
    commentable.user
  end

  def last?
    self.commentable.comments.last == self
  end

  def create_activities
    (commenters_on_commentable + [owner]).uniq.each do |user|
      Activity.create(
        subject: self,
        name: 'comment_posted',
        direction: 'to',
        user: user
      )
    end
  end

  def destroy_activities
    Activity.where(subject: self).each do |a|
      a.destroy
    end
  end

  def commenters_on_commentable
    Comment.where(commentable: commentable).map(&:user).uniq
  end

  def can_be_destroyed_by?(user)
    !user.nil? && (user.admin? || (self.user == user && last?))
  end
end
