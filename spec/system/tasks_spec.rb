require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path

        fill_in 'タイトル', with: '書類作成'
        fill_in '内容', with: '企画書を作成する。'
        fill_in '終了期限', with: Date.current
        select '中', from: '優先度'
        select '未着手', from: 'ステータス'

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
        :second_task,
        created_at: Time.zone.parse('2022-02-17 00:00:00')
      )
    end

    let!(:third_task) do
      FactoryBot.create(
        :third_task,
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
        expect(page).to have_selector(
          'tbody tr:nth-child(1)',
          text: 'first_task'
        )

        expect(page).to have_selector(
          'tbody tr:nth-child(2)',
          text: 'second_task'
        )

        expect(page).to have_selector(
          'tbody tr:nth-child(3)',
          text: 'third_task'
        )
      end
    end

    describe 'ソート機能' do
      context '「終了期限」というリンクをクリックした場合' do
        it '終了期限昇順に並び替えられたタスク一覧が表示される' do
          click_link '終了期限'

          expect(page).to have_selector(
            'tbody tr:nth-child(1)',
            text: 'third_task'
          )

          expect(page).to have_selector(
            'tbody tr:nth-child(2)',
            text: 'second_task'
          )

          expect(page).to have_selector(
            'tbody tr:nth-child(3)',
            text: 'first_task'
          )
        end
      end

      context '「優先度」というリンクをクリックした場合' do
        it '優先度の高い順に並び替えられたタスク一覧が表示される' do
          click_link '優先度'

          expect(page).to have_selector(
            'tbody tr:nth-child(1)',
            text: 'second_task'
          )

          expect(page).to have_selector(
            'tbody tr:nth-child(2)',
            text: 'first_task'
          )

          expect(page).to have_selector(
            'tbody tr:nth-child(3)',
            text: 'third_task'
          )
        end
      end
    end

    describe '検索機能' do
      context 'タイトルであいまい検索をした場合' do
        it '検索ワードを含むタスクのみ表示される' do
          fill_in 'タイトル', with: 'first'
          click_button '検索'

          expect(page).to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
          expect(page).not_to have_content 'third_task'
        end
      end

      context 'ステータスで検索した場合' do
        it '検索したステータスに一致するタスクのみ表示される' do
          select '完了', from: 'ステータス'
          click_button '検索'

          expect(page).to have_content 'third_task'
          expect(page).not_to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
        end
      end

      context 'タイトルとステータスで検索した場合' do
        it '検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される' do
          fill_in 'タイトル', with: 'third'
          select '完了', from: 'ステータス'

          click_button '検索'

          expect(page).to have_content 'third_task'
          expect(page).not_to have_content 'first_task'
          expect(page).not_to have_content 'second_task'
        end
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        click_link 'タスクを登録する'

        fill_in 'タイトル', with: 'new_task'
        fill_in '内容', with: '新しいタスクです'
        fill_in '終了期限', with: Date.current
        select '中', from: '優先度'
        select '未着手', from: 'ステータス'

        click_button '登録する'

        expect(page).to have_selector(
          'tbody tr:nth-child(1)',
          text: 'new_task'
        )
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        task = FactoryBot.create(:task)

        visit task_path(task)

        expect(page).to have_content 'first_task'
        expect(page).to have_content '1つ目のタスクです。'
      end
    end
  end
end