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

  attr_accessor :exif

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

  after_image_post_process :save_exif
  after_initialize :load_exif

  def next(context = nil)
    Photo.contextual(context).where("id < ?", id).last
  end

  def prev(context = nil)
    Photo.contextual(context).where("id > ?", id).first
  end

  def self.contextual(context = nil)
    return default_scoped.merge(context.photos) if context
    default_scoped
  end

  private

  def user_quota
    return false unless user
    # todo: remove quota settings to user profile
    if user.photos.today.count >= user.photo_upload_daily_limit
      errors.add(:base, I18n.t('photos.uploader.errors.exceeds_daily_limit'))
    elsif  user.photos.this_week.count >= user.photo_upload_weekly_limit
      errors.add(:base, I18n.t('photos.uploader.errors.exceeds_weekly_limit'))
    end
  end

  def save_exif
    exif =  Exif::Parser.new(image.queued_for_write[:original].path)
    self.exif_binary = Marshal.dump(exif)
    logger.debug "marshaling exif successfully. size #{exif_binary.length}"
  rescue
    self.exif_binary = nil
    logger.debug "marshaling exif failed"
  end

  def load_exif
    self.exif = Marshal.load(self.exif_binary)
    logger.debug "unmarshaling exif_binary successfullty #{exif.inspect}"
  rescue
    self.exif_binary = nil
    logger.debug "unmarshaling exif_binary failed"
  end
end
