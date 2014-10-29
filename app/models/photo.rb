class Photo < ActiveRecord::Base
  belongs_to :user
  validate :user_quota, :on => :create

  LIMIT_PHOTOS_DAILY = 5
  LIMIT_PHOTOS_WEEKLY = 15
  LIMIT_PHOTO_SIZE_UP = 5.megabytes
  LIMIT_PHOTO_SIZE_DOWN = 100.kilobytes

  validates :title,
            length: { maximum: 100 }

  has_attached_file :image,
                    :styles => {
                        :original => ["2048x2048>", :jpg],
                        :medium => ["1280x720>", :jpg],
                        :small => ["x240>", :jpg],
                        :thumb => ["100x100#", :jpg]
                    },
                    :convert_options => {
                        :medium => "-strip",
                        :small => "-quality 75 -strip",
                        :thumb => "-quality 75 -strip"
                    }


  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: /\Aimage\/.*\Z/ },
                       size: { in: LIMIT_PHOTO_SIZE_DOWN..LIMIT_PHOTO_SIZE_UP }

  def get_url(style)
    if Rails.env.production?
      # default url
      return image.url(style) unless image?
      # get GAPI Url
      data = "photos/images/#{self.id}"
      hash_secret = Paperclip::Attachment.default_options[:hash_secret]
      hash_digest = Paperclip::Attachment.default_options[:hash_digest]
      hash = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.const_get(hash_digest).new, hash_secret, data)
      "https://photoblogapp.storage.googleapis.com/photos/images/#{hash}/#{self.id}_#{style}.jpg"
    else
      image.url(style)
    end
  end

  private

  def user_quota
    # todo: remove quota settings to user profile
    if user.photos.today.count >= LIMIT_PHOTOS_DAILY
      errors.add(:base, I18n.t('photos.uploader.errors.exceeds_daily_limit'))
    elsif  user.photos.this_week.count >= LIMIT_PHOTOS_WEEKLY
      errors.add(:base, I18n.t('photos.uploader.errors.exceeds_weekly_limit'))
    end
  end
end
