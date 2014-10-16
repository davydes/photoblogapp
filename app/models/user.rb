class User < ActiveRecord::Base
  validates :name,
            presence: true,
            length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_secure_password
  validates :password, :presence => true,
                       :length   => { :within => 6..40 },
                       :if       => :password_changed?

  has_many :articles

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private

  def password_changed?
    !@password.blank? or password_digest.blank?
  end

  def create_remember_token
    self.remember_token = User.digest(User.new_remember_token)
  end
end
