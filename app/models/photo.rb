class Photo < ActiveRecord::Base
  default_scope { order('id desc') }
  scope :today, -> { where(:created_at => (Time.now.beginning_of_day..Time.now)) }
  scope :this_week, -> { where(:created_at => (Time.now.beginning_of_week..Time.now)) }

  belongs_to :user
  has_many :votes, as: :voteable
  has_many :albums_photos
  has_many :albums, :through => :albums_photos
  has_many :articles_photos
  has_many :articles, :through => :articles_photos, :dependent => :restrict_with_exception
  has_attached_file :image,
                    :styles => {
                        :original => ["2048x2048>",:jpg],
                        :medium   => ["1280x720>", :jpg],
                        :s640     => ["640x640>",  :jpg],
                        :s500     => ["500x500>",  :jpg],
                        :s320     => ["320x320>",  :jpg],
                        :s240     => ["240x240>",  :jpg],
                        :s100     => ["100x100>",  :jpg],
                        :thumb    => ["120x120#",  :jpg]
                    },
                    :convert_options => {
                        :medium => "-strip",
                        :s640   => "-quality 80 -strip",
                        :s500   => "-quality 80 -strip",
                        :s320   => "-quality 80 -strip",
                        :s240   => "-quality 80 -strip",
                        :s100   => "-quality 80 -strip",
                        :thumb  => "-quality 90 -strip"
                    }

  attr_accessor :exif
  paginates_per 50

  LIMIT_PHOTO_SIZE_UP = 5.megabytes
  LIMIT_PHOTO_SIZE_DOWN = 100.kilobytes

  VALIDATION_MAX_TITLE = 50
  VALIDATION_MAX_DESCRIPTION = 250

  validate :user_quota, :on => :create
  validates :user, presence: true
  validates :title,
            presence: true,
            length: { maximum: VALIDATION_MAX_TITLE }
  validates :description,
            length: { maximum: VALIDATION_MAX_DESCRIPTION }
  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: /\Aimage\/.*\Z/ },
                       size: { in: LIMIT_PHOTO_SIZE_DOWN..LIMIT_PHOTO_SIZE_UP }

  after_image_post_process :save_exif
  after_initialize :load_exif

  def next(context = nil)
    Photo.contextual(context).where("id < ?", id).first
  end

  def prev(context = nil)
    Photo.contextual(context).where("id > ?", id).last
  end

  def self.contextual(context = nil)
    context ? default_scoped.merge(context.photos) : default_scoped
  end

  def page(context = nil, order = :id)
    position = Photo.contextual(context).where("#{order} >= ?", self.send(order)).count
    (position.to_f/Photo.default_per_page).ceil
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
    self.exif =  Utils::Exif.new(image.queued_for_write[:original].path)
    self.exif_binary = exif.to_binary
    logger.debug "EXIF saved successfully. Size: #{exif_binary.length} bytes"
  rescue => e
    self.exif_binary = nil
    logger.error "EXIF save failed: #{e.message}"
  end

  def load_exif
    if self.exif_binary
      self.exif =  Utils::Exif.from_binary(self.exif_binary)
      logger.debug "EXIF load successfully"
    else
      logger.debug "EXIF not exists"
    end
  rescue => e
    self.exif = nil
    logger.error "EXIF load failed: #{e.message}"
  end
end
