50.times do |n|
  Task.create!(
    title: "タスク#{n + 1}",
    content: "タスク#{n + 1}の内容"
  )
end