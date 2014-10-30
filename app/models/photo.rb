class Photo < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :albums
  has_attached_file :image,
                    :styles => {
                        :original => ["2048x2048>", :jpg],
                        :medium => ["1280x720>", :jpg],
                        :small => ["x240>", :jpg],
                        :thumb => ["120x120#", :jpg]
                    },
                    :convert_options => {
                        :medium => "-strip",
                        :small => "-quality 80 -strip",
                        :thumb => "-quality 80 -strip"
                    }

  LIMIT_PHOTOS_DAILY = 5
  LIMIT_PHOTOS_WEEKLY = 15
  LIMIT_PHOTO_SIZE_UP = 5.megabytes
  LIMIT_PHOTO_SIZE_DOWN = 100.kilobytes

  validate :user_quota, :on => :create
  validates :user, presence: true
  validates :title,
            length: { maximum: 100 }
  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: /\Aimage\/.*\Z/ },
                       size: { in: LIMIT_PHOTO_SIZE_DOWN..LIMIT_PHOTO_SIZE_UP }

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
