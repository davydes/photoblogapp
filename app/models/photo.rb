class Photo < ActiveRecord::Base
  belongs_to :user
  validate :user_quota, :on => :create

  validates :title,
            length: { maximum: 100 }

  has_attached_file :image,
                    :styles => {
                        :original => ["2048x2048>", :jpg],
                        :medium => ["720x720>", :jpg],
                        :thumb => ["150x150#", :jpg]
                    }

  validates_attachment :image,
                       presence: true,
                       content_type: { content_type: /\Aimage\/.*\Z/ },
                       size: { in: 100.kilobytes..5.megabytes }

  private

  def user_quota
    # todo: remove quota settings to user profile
    if user.photos.today.count >= 5
      errors.add(:base, I18n.t('photos.uploader.errors.exceeds_daily_limit'))
    elsif  user.photos.this_week.count >= 15
      errors.add(:base, I18n.t('photos.uploader.errors.exceeds_weekly_limit'))
    end
  end
end
