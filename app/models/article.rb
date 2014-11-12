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

  def photos_hash
    photos_hash = {}
    content.gsub(Article::PHOTO_TAG) do |m|
      if !photos_hash.has_key?($1) && Photo.exists?($1)
        photos_hash[$1] =  Photo.find($1)
      end
    end
    return photos_hash
  end

  private

  def relink_photos
    self.photos.delete_all
    photos_hash.each { |k,v| self.photos << v }
  end
end
