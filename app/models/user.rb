class User < ActiveRecord::Base
  validates :name,
            presence: true,
            length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :password, :presence => true,
                       :length   => { :within => 6..40 },
                       :if       => :password_changed?

  has_attached_file :avatar,
                    :styles => {
                        :original => {
                            :processors => [:cropper, :thumbnail],
                            :geometry => "500x500>"
                        },
                        :thumb => "32x32!"
                    },
                    :default_url => "avatar.png"
  validates_attachment_presence :avatar
  validates_attachment_size :avatar, :less_than => 500.kilobytes
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  has_secure_password
  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_many :articles

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

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

  private

  def password_changed?
    !@password.blank? or password_digest.blank?
  end

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end

  def reprocess_avatar
    avatar.reprocess!
  end
end
