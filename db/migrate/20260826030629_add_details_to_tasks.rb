class AddDetailsToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :deadline_on, :date
    add_column :tasks, :priority, :integer
    add_column :tasks, :status, :integer

    reversible do |dir|
      dir.up do
        execute <<~SQL
          UPDATE tasks
          SET deadline_on = CURRENT_DATE,
              priority = 1,
              status = 0
        SQL
      end
    end

    change_column_null :tasks, :deadline_on, false
    change_column_null :tasks, :priority, false
    change_column_null :tasks, :status, false
  end
end