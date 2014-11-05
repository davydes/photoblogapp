FactoryGirl.define do
  factory :photo do
    sequence (:title) { |n| "photo#{n}" }
    description { "This is description of photo #{title}" }
    image_file_name { 'FakeFile.jpg' }
    image_content_type { 'image/jpeg' }
    image_file_size { 2.megabyte }

    association :user, factory: :user
  end
end