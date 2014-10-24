class Photo < ActiveRecord::Base
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

  belongs_to :user
end
