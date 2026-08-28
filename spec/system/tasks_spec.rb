require "rails_helper"

RSpec.describe "タスク管理機能", type: :system do
  let!(:user) { FactoryBot.create(:user) }

  def login_as(user)
    visit new_session_path

    fill_in "メールアドレス", with: user.email
    fill_in "パスワード", with: "password"

    click_button "ログイン"

    expect(page).to have_current_path(tasks_path)
  end

  describe "登録機能" do
    before do
      login_as(user)
    end

    context "タスクを登録した場合" do
      it "登録したタスクが表示される" do
        find("#new-task").click

        fill_in "タイトル", with: "書類作成"
        fill_in "内容", with: "企画書を作成する。"
        fill_in "終了期限", with: Date.current
        select "中", from: "優先度"
        select "未着手", from: "ステータス"

        click_button "登録する"

        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content "書類作成"
      end
    end
  end

  describe "一覧表示機能" do
    let!(:first_task) do
      FactoryBot.create(
        :task,
        user: user,
        title: "first_task",
        created_at: Time.zone.parse("2022-02-18 00:00:00")
      )
    end

    let!(:second_task) do
      FactoryBot.create(
        :second_task,
        user: user,
        created_at: Time.zone.parse("2022-02-17 00:00:00")
      )
    end

    let!(:third_task) do
      FactoryBot.create(
        :third_task,
        user: user,
        created_at: Time.zone.parse("2022-02-16 00:00:00")
      )
    end

    let!(:work_label) do
      FactoryBot.create(
        :label,
        user: user,
        name: "仕事"
      )
    end

    let!(:study_label) do
      FactoryBot.create(
        :label,
        user: user,
        name: "勉強"
      )
    end

    let!(:first_task_label) do
      FactoryBot.create(
        :task_label,
        task: first_task,
        label: work_label
      )
    end

    let!(:second_task_label) do
      FactoryBot.create(
        :task_label,
        task: second_task,
        label: work_label
      )
    end

    let!(:third_task_label) do
      FactoryBot.create(
        :task_label,
        task: third_task,
        label: study_label
      )
    end

    before do
      login_as(user)
    end

    context "一覧画面に遷移した場合" do
      it "作成済みのタスク一覧が表示される" do
        expect(page).to have_content "first_task"
        expect(page).to have_content "second_task"
        expect(page).to have_content "third_task"
      end

      it "作成済みのタスク一覧が作成日時の降順で表示される" do
        expect(page).to have_selector(
          "tbody tr:nth-child(1)",
          text: "first_task"
        )

        expect(page).to have_selector(
          "tbody tr:nth-child(2)",
          text: "second_task"
        )

        expect(page).to have_selector(
          "tbody tr:nth-child(3)",
          text: "third_task"
        )
      end
    end

    describe "ソート機能" do
      context "「終了期限」というリンクをクリックした場合" do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          click_link "終了期限"

          expect(page).to have_selector(
            "tbody tr:nth-child(1)",
            text: "third_task"
          )

          expect(page).to have_selector(
            "tbody tr:nth-child(2)",
            text: "second_task"
          )

          expect(page).to have_selector(
            "tbody tr:nth-child(3)",
            text: "first_task"
          )
        end
      end

      context "「優先度」というリンクをクリックした場合" do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          click_link "優先度"

          expect(page).to have_selector(
            "tbody tr:nth-child(1)",
            text: "second_task"
          )

          expect(page).to have_selector(
            "tbody tr:nth-child(2)",
            text: "first_task"
          )

          expect(page).to have_selector(
            "tbody tr:nth-child(3)",
            text: "third_task"
          )
        end
      end
    end

    describe "検索機能" do
      context "タイトルであいまい検索をした場合" do
        it "検索ワードを含むタスクのみ表示される" do
          fill_in "タイトル", with: "first"
          click_button "検索"

          expect(page).to have_content "first_task"
          expect(page).not_to have_content "second_task"
          expect(page).not_to have_content "third_task"
        end
      end

      context "ステータスで検索した場合" do
        it "検索したステータスに一致するタスクのみ表示される" do
          select "完了", from: "ステータス"
          click_button "検索"

          expect(page).to have_content "third_task"
          expect(page).not_to have_content "first_task"
          expect(page).not_to have_content "second_task"
        end
      end

      context "タイトルとステータスで検索した場合" do
        it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
          fill_in "タイトル", with: "third"
          select "完了", from: "ステータス"

          click_button "検索"

          expect(page).to have_content "third_task"
          expect(page).not_to have_content "first_task"
          expect(page).not_to have_content "second_task"
        end
      end

      context "ラベルで検索をした場合" do
        it "そのラベルの付いたタスクがすべて表示される" do
          select "仕事", from: "ラベル"

          click_button "検索"

          expect(page).to have_content "first_task"
          expect(page).to have_content "second_task"
          expect(page).not_to have_content "third_task"
        end
      end
    end

    context "新たにタスクを作成した場合" do
      it "新しいタスクが一番上に表示される" do
        find("#new-task").click

        fill_in "タイトル", with: "new_task"
        fill_in "内容", with: "新しいタスクです"
        fill_in "終了期限", with: Date.current
        select "中", from: "優先度"
        select "未着手", from: "ステータス"

        click_button "登録する"

        expect(page).to have_current_path(tasks_path)

        expect(page).to have_selector(
          "tbody tr:nth-child(1)",
          text: "new_task"
        )
      end
    end
  end

  describe "詳細表示機能" do
    let!(:task) do
      FactoryBot.create(
        :task,
        user: user,
        title: "first_task",
        content: "1つ目のタスクです。"
      )
    end

    before do
      login_as(user)
    end

    context "任意のタスク詳細画面に遷移した場合" do
      it "そのタスクの内容が表示される" do
        within("tr", text: task.title) do
          find(".show-task").click
        end

        expect(page).to have_content "first_task"
        expect(page).to have_content "1つ目のタスクです。"
      end
    end
  end
end