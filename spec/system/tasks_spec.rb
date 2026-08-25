require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path

        fill_in 'Title', with: '書類作成'
        fill_in 'Content', with: '企画書を作成する。'

        click_button 'Create Task'

        expect(page).to have_content '書類作成'
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのタスク一覧が表示される' do
        FactoryBot.create(:task)

        visit tasks_path
        
        expect(page).to have_content '書類作成'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task)

        visit task_path(task)

        expect(page).to have_content '書類作成'
        expect(page).to have_content '企画書を作成する。'
      end
    end
  end
end
