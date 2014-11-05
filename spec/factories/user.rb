FactoryGirl.define do
  factory :user do
    sequence (:name) { |n| "user#{n}" }
    email { "#{name}@example.org" }
    password "secret"
    password_confirmation "secret"
    trait :admin do
      admin true
    end
  end
end