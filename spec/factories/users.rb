FactoryBot.define do
  factory :user do
    name { "一般ユーザ" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end

  factory :admin_user, parent: :user do
    name { "管理ユーザ" }
    admin { true }
  end
end