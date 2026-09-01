require "rails_helper"

RSpec.describe TaskLabel, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:task) { FactoryBot.create(:task, user: user) }
  let(:label) { FactoryBot.create(:label, user: user) }

  context "タスクとラベルがある場合" do
    it "中間テーブルのデータを登録できる" do
      task_label = TaskLabel.new(
        task: task,
        label: label
      )

      expect(task_label).to be_valid
    end
  end

  context "タスクがない場合" do
    it "登録できない" do
      task_label = TaskLabel.new(
        task: nil,
        label: label
      )

      expect(task_label).not_to be_valid
    end
  end

  context "ラベルがない場合" do
    it "登録できない" do
      task_label = TaskLabel.new(
        task: task,
        label: nil
      )

      expect(task_label).not_to be_valid
    end
  end
end