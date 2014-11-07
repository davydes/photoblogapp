class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photo_album_links
  has_many :photos, through: :photo_album_links

  validates :user, presence: true
  validates :title,
            presence: true,
            format: { with: /\A[\w[а-я] ,-]+\z/i },
            length: { :within => 3..50 }
end
