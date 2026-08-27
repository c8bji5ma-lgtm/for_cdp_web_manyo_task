FactoryBot.define do
  factory :task do
    association :user

    title { "first_task" }
    content { "1つ目のタスクです。" }
    deadline_on { Date.new(2022, 2, 18) }
    priority { "中" }
    status { "未着手" }
  end

  factory :second_task, class: Task do
    association :user

    title { "second_task" }
    content { "2つ目のタスクです。" }
    deadline_on { Date.new(2022, 2, 17) }
    priority { "高" }
    status { "着手中" }
  end

  factory :third_task, class: Task do
    association :user

    title { "third_task" }
    content { "3つ目のタスクです。" }
    deadline_on { Date.new(2022, 2, 16) }
    priority { "低" }
    status { "完了" }
  end
end