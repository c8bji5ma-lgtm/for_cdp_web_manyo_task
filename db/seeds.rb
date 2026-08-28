general_user = User.find_or_initialize_by(email: "general@example.com")

general_user.assign_attributes(
  name: "一般ユーザ",
  password: "password",
  password_confirmation: "password",
  admin: false
)

general_user.save!


admin_user = User.find_or_initialize_by(email: "admin@example.com")

admin_user.assign_attributes(
  name: "管理ユーザ",
  password: "password",
  password_confirmation: "password",
  admin: true
)

admin_user.save!


50.times do |n|
  task = general_user.tasks.find_or_initialize_by(
    title: "一般ユーザのタスク#{n + 1}"
  )

  task.assign_attributes(
    content: "一般ユーザのタスク#{n + 1}の内容です。",
    deadline_on: Date.current + n.days,
    priority: ["高", "中", "低"][n % 3],
    status: ["未着手", "着手中", "完了"][n % 3]
  )

  task.save!
end


50.times do |n|
  task = admin_user.tasks.find_or_initialize_by(
    title: "管理ユーザのタスク#{n + 1}"
  )

  task.assign_attributes(
    content: "管理ユーザのタスク#{n + 1}の内容です。",
    deadline_on: Date.current + n.days,
    priority: ["高", "中", "低"][n % 3],
    status: ["未着手", "着手中", "完了"][n % 3]
  )

  task.save!
end