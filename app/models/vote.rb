class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true

  validates :user, presence: true

  after_create :create_activities
  after_destroy :destroy_activities

  def owner
    voteable.user
  end

  def create_activities
    Activity.create(
      subject: self,
      name: 'vote_posted',
      direction: 'to',
      user: owner
    )
  end

  def destroy_activities
    Activity.where(subject: self).each do |a|
      a.destroy
    end
  end

  def can_be_destroyed_by?(user)
    !user.nil? && (user.admin? || self.user == user)
  end
end