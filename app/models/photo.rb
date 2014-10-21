class Photo < ActiveRecord::Base
  validates :title,
            presence: true,
            length: { maximum: 100 }

  has_attached_file :image,
                    :styles => {
                        :original => ["2048x2048>", :jpg],
                        :medium => ["500x500>", :jpg],
                        :thumb => ["150x150#", :jpg]
                    }

  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes

  belongs_to :user
end
