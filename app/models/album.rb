class Album < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :photos

  validates :user, presence: true
end
