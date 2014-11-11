class Article < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :photos

  validates :title,
            presence: true,
            length: { maximum: 100 }
  validates :content,
            presence: true,
            length: { minimum: 10 }

  validates :user, presence: true

  before_save :relink_photos

  PHOTO_TAG = /\{\{photo#(\d+)\}\}/

  private

  def relink_photos
    photos.delete_all
    content.gsub(Article::PHOTO_TAG) do |m|
      if Photo.exists?($1)
        photos << Photo.find($1)
      end
    end
  end
end
