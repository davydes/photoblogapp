class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :voteable, :polymorphic => true

  validates :user, presence: true

  def can_be_destroyed_by?(user)
    !user.nil? && (user.admin? || self.user == user)
  end
end