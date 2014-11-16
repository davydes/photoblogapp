class Photo < ActiveRecord::Base
  scope :today, -> { where(:created_at => (Time.now.beginning_of_day..Time.now)) }
  scope :this_week, -> { where(:created_at => (Time.now.beginning_of_week..Time.now)) }

  belongs_to :user
  has_many :albums_photos
  has_many :albums, :through => :albums_photos
  has_many :articles_photos
  has_many :articles, :through => :articles_photos, :dependent => :restrict_with_exception
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
            length: { maximum: 50 }
  validates :description,
            length: { maximum: 250 }
  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: /\Aimage\/.*\Z/ },
                       size: { in: LIMIT_PHOTO_SIZE_DOWN..LIMIT_PHOTO_SIZE_UP }

  def next(context = nil)
    Photo.contextual(context).where("id < ?", id).last
  end

  def prev(context = nil)
    Photo.contextual(context).where("id > ?", id).first
  end

  def self.contextual(context = nil)
    # album/article context
    /\A(?<entity>article|album)\-(?<id>\d+)\z/.match(context) { |m|
      raise "#{m[:entity]} #{m[:id]} does not exists" unless Object.const_get(m[:entity].classify).exists?(m[:id])
      return joins("#{m[:entity].pluralize}_photos".to_sym).where("#{m[:entity]}_id = ?", m[:id])
    }
    raise "undefined context: #{context}" if context
    return default_scoped
  end

  private

  def user_quota
    return false unless user
    # todo: remove quota settings to user profile
    if user.photos.today.count >= LIMIT_PHOTOS_DAILY
      errors.add(:base, I18n.t('photos.uploader.errors.exceeds_daily_limit'))
    elsif  user.photos.this_week.count >= LIMIT_PHOTOS_WEEKLY
      errors.add(:base, I18n.t('photos.uploader.errors.exceeds_weekly_limit'))
    end
  end
end
