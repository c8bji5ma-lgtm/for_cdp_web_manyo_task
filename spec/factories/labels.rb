FactoryBot.define do
  factory :label do
    association :user

    sequence(:name) { |n| "label_#{n}" }
  end
end