require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path

        fill_in 'タイトル', with: '書類作成'
        fill_in '内容', with: '企画書を作成する。'

        click_button '登録する'

        expect(page).to have_content '書類作成'
      end
    end
  end

  describe '一覧表示機能' do
    before do
      Task.delete_all
    end

    let!(:first_task) do
      FactoryBot.create(
        :task,
        title: 'first_task',
        created_at: Time.zone.parse('2022-02-18 00:00:00')
      )
    end

    let!(:second_task) do
      FactoryBot.create(
        :task,
        title: 'second_task',
        created_at: Time.zone.parse('2022-02-17 00:00:00')
      )
    end

    let!(:third_task) do
      FactoryBot.create(
        :task,
        title: 'third_task',
        created_at: Time.zone.parse('2022-02-16 00:00:00')
      )
    end

    before do
      visit tasks_path
    end

    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        expect(page).to have_content 'first_task'
        expect(page).to have_content 'second_task'
        expect(page).to have_content 'third_task'
      end

      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')

        expect(task_list[0]).to have_content 'first_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        click_link 'タスクを登録する'

        fill_in 'タイトル', with: 'new_task'
        fill_in '内容', with: '新しいタスクです'

        click_button '登録する'

        task_list = all('tbody tr')

        expect(task_list[0]).to have_content 'new_task'
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