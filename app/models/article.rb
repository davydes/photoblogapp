class Article < ActiveRecord::Base
  include Impressionable

  scope :drafts, -> { where(published: false, sandbox: false) }
  scope :published, -> { where(published: true) }
  scope :sandbox, -> { where(sandbox: true) }

  belongs_to :user
  has_and_belongs_to_many :photos
  has_many :comments, as: :commentable

  VALIDATION_MAX_TITLE = 50
  VALIDATION_MAX_INTRO = 255
  VALIDATION_MIN_CONTENT = 10

  validates :title,
            presence: true,
            length: { maximum: VALIDATION_MAX_TITLE }
  validates :intro,
            presence: true,
            length: { maximum: VALIDATION_MAX_INTRO }
  validates :content,
            presence: true,
            length: { minimum: VALIDATION_MIN_CONTENT }

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
    photos_hash
  end

  def unpublish
    self.attributes = {:published_at => nil, :published => false}
    save
  end

  def publish
    self.attributes = {:published_at => Time.now, :published => true}
    save
  end

  def publish_to_sandbox
    self.attributes = {:sandbox_at => Time.now, :sandbox => true}
    save
  end

  def can_be_published_by?(user)
    !self.published && user && user.publisher && user_id == user.id
  end

  def can_be_published_to_sandbox_by?(user)
    !self.sandbox && user && user_id == user.id
  end

  def is_draft?
    !self.published && !self.sandbox
  end

  def published_at
    read_attribute(:published_at) || self.created_at
  end

  def sandbox_at
    read_attribute(:sandbox_at_at) || self.created_at
  end

  private

  def relink_photos
    self.photos.delete_all
    photos_hash.each { |k,v| self.photos << v }
  end
end
