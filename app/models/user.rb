class User < ActiveRecord::Base

  #fields

  has_secure_password
  has_attached_file :avatar,
                    :styles => {
                        :original => {
                            :processors => [:cropper, :thumbnail],
                            :geometry => "500x500>",
                            :format => :png
                        },
                        :thumb => ["32x32!", :png]
                    },
                    :default_url => "avatar_:style.png"
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  #asociations

  has_many :articles, :dependent => :destroy
  has_many :albums, :dependent => :destroy
  has_many :photos, :dependent => :destroy
  has_many :comments

  #validations
    # REGEX
    REAL_NAME_REGEX = /\A[\da-zа-яё ,.'\-_]*\z/i

  validates :name, presence: true, format: { with: /\A\w{3,}\z/i },
            length: { maximum: 50 },
            uniqueness: { case_sensitive: false }

  validates :email,
            presence: true,
            length: { maximum: 100 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { :within => 6..40 }, if: :password_changed?
  validates :first_name, format: { with: REAL_NAME_REGEX }, length: { maximum: 50 }
  validates :last_name,  format: { with: REAL_NAME_REGEX }, length: { maximum: 50 }
  validates :gender, inclusion: [:m, :f, 'm', 'f', nil]
  validate :at_least_18
  validates_attachment :avatar, less_than: 1.megabytes, content_type: { content_type: /\Aimage\/.*\Z/ }

  #callbacks

  before_save {
    self.email = email.downcase
    self.name = name.downcase
  }

  #methods

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def cropping?
    !(crop_x.blank? or crop_y.blank? or crop_w.blank? or crop_h.blank?)
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))
  end

  def send_password_reset
    generate_token(:password_reset_token)
    update_attribute(:password_reset_sent_at, Time.zone.now)
    UserMailer.password_reset(self).deliver
  end

  def drop_password_reset_token
    update_attribute(:password_reset_token, nil)
  end

  def new_remember_token
    generate_token(:remember_token)
  end

  def self.find_for_auth(login)
    self.find_by_email(login) || self.find_by_name(login)
  end

  def photo_upload_daily_limit
    read_attribute(:photo_upload_daily_limit)||5
  end

  def photo_upload_weekly_limit
    read_attribute(:photo_upload_weekly_limit)||15
  end

  def upload_photo_available
    [self.photo_upload_daily_limit - self.photos.today.count,
     self.photo_upload_weekly_limit - self.photos.this_week.count].min
  end

  def last_login_time
    read_attribute(:last_login_time) || created_at
  end

  def online?
    last_login_time && last_login_time >= 10.minutes.ago
  end

  def admin?
    admin
  end

  def can_destroy?(resource)
    resource.can_be_destroyed_by?(self)
  end

  private

  def password_changed?
    !@password.blank? or password_digest.blank?
  end

  def generate_token(column)
    begin
      token = SecureRandom.urlsafe_base64
      digest_token =  User.digest(token)
    end while User.exists?(column => digest_token)
    update_attribute(column, digest_token)
    token
  end

  def at_least_18
    if self.date_of_birth
      errors.add(:date_of_birth, I18n.t('users.error.too_young')) if self.date_of_birth > 18.years.ago
    end
  end
end
