priorities = ['低', '中', '高']
statuses = ['未着手', '着手中', '完了']

50.times do |n|
  Task.create!(
    title: "タスク#{n + 1}",
    content: "タスク#{n + 1}の内容",
    deadline_on: Date.current + n.days,
    priority: priorities[n % priorities.length],
    status: statuses[n % statuses.length]
  )
end