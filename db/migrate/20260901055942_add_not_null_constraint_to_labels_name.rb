class AddNotNullConstraintToLabelsName < ActiveRecord::Migration[8.1]
  def change
    change_column_null :labels, :name, false
  end
end