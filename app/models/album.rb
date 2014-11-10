class Album < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :photos

  validates :user, presence: true
  validates :title,
            presence: true,
            format: { with: /\A[\w[а-я] ,-]+\z/i },
            length: { :within => 3..50 }
end
