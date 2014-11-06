class User < ActiveRecord::Base
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
  has_many :articles, :dependent => :destroy
  has_many :albums, :dependent => :destroy
  has_many :photos, :dependent => :destroy do
    def today
      where(:created_at => (Time.now.beginning_of_day..Time.now))
    end
    def this_week
      where(:created_at => (Time.now.beginning_of_week..Time.now))
    end
  end

  VALID_NAME_REGEX = /\A\w{3,}\z/i
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,
            presence: true,
            format: { with: VALID_NAME_REGEX },
            length: { maximum: 50 },
            uniqueness: { case_sensitive: false }
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            length: { maximum: 100 },
            uniqueness: { case_sensitive: false }
  validates :password, :presence => true,
                       :length   => { :within => 6..40 },
                       :if       => :password_changed?
  validates_attachment :avatar,
                       less_than: 1.megabytes,
                       content_type: { content_type: /\Aimage\/.*\Z/ }
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  before_save {
    self.email = email.downcase
    self.name = name.downcase
  }

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
    return token
  end
end
