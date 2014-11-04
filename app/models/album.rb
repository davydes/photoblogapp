class Album < ActiveRecord::Base
  belongs_to :user
  has_many :photo_album_links
  has_many :photos, through: :photo_album_links

  validates :user, presence: true
end
