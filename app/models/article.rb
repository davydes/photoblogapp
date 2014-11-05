class Article < ActiveRecord::Base
  belongs_to :user

  validates :title,
            presence: true,
            length: { maximum: 100 }
  validates :content,
            presence: true,
            length: { minimum: 10 }

  validates :user, presence: true
end
