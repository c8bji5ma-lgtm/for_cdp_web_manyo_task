require "rails_helper"

RSpec.describe "ユーザ管理機能", type: :system do
  describe "登録機能" do
    context "ユーザを登録した場合" do
      it "タスク一覧画面に遷移する" do
        visit new_user_path

        fill_in "名前", with: "テストユーザ"
        fill_in "メールアドレス", with: "test@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"

        click_button "登録する"

        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content "アカウントを登録しました"
      end
    end

    context "ログインせずにタスク一覧画面に遷移した場合" do
      it "ログイン画面に遷移し、「ログインしてください」というメッセージが表示される" do
        visit tasks_path

        expect(page).to have_current_path(new_session_path)
        expect(page).to have_content "ログインしてください"
      end
    end
  end

  describe "ログイン機能" do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:user) }

    before do
      visit new_session_path

      fill_in "メールアドレス", with: user.email
      fill_in "パスワード", with: "password"

      click_button "ログイン"

      expect(page).to have_current_path(tasks_path)
    end

    context "登録済みのユーザでログインした場合" do
      it "タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される" do
        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content "ログインしました"
      end

      it "自分の詳細画面にアクセスできる" do
        visit user_path(user)

        expect(page).to have_current_path(user_path(user))
        expect(page).to have_content "アカウント詳細ページ"
        expect(page).to have_content user.name
        expect(page).to have_content user.email
      end

      it "他人の詳細画面にアクセスすると、タスク一覧画面に遷移する" do
        visit user_path(other_user)

        expect(page).to have_current_path(tasks_path)
      end

      it "ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される" do
        find("#sign-out").click

        expect(page).to have_current_path(new_session_path)
        expect(page).to have_content "ログアウトしました"
      end
    end
  end

  describe "管理者機能" do
    let!(:admin_user) { FactoryBot.create(:admin_user) }
    let!(:user) { FactoryBot.create(:user) }

    context "管理者がログインした場合" do
      before do
        visit new_session_path

        fill_in "メールアドレス", with: admin_user.email
        fill_in "パスワード", with: "password"

        click_button "ログイン"

        expect(page).to have_current_path(tasks_path)
      end

      it "ユーザ一覧画面にアクセスできる" do
        visit admin_users_path

        expect(page).to have_current_path(admin_users_path)
        expect(page).to have_content "ユーザ一覧ページ"
        expect(page).to have_content admin_user.name
        expect(page).to have_content user.name
      end

      it "管理者を登録できる" do
        visit new_admin_user_path

        fill_in "名前", with: "新しい管理者"
        fill_in "メールアドレス", with: "new-admin@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"
        check "管理者権限"

        click_button "登録する"

        expect(page).to have_current_path(admin_users_path)
        expect(page).to have_content "ユーザを登録しました"
        expect(page).to have_content "新しい管理者"
        expect(page).to have_content "あり"
      end

      it "ユーザ詳細画面にアクセスできる" do
        visit admin_user_path(user)

        expect(page).to have_current_path(admin_user_path(user))
        expect(page).to have_content "ユーザ詳細ページ"
        expect(page).to have_content user.name
        expect(page).to have_content user.email
      end

      it "ユーザ編集画面から、自分以外のユーザを編集できる" do
        visit edit_admin_user_path(user)

        fill_in "名前", with: "編集済みユーザ"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認）", with: "password"

        click_button "更新する"

        expect(page).to have_current_path(admin_users_path)
        expect(page).to have_content "ユーザを更新しました"
        expect(page).to have_content "編集済みユーザ"
      end

      it "ユーザを削除できる" do
        visit admin_users_path

        within("tr", text: user.email) do
          accept_confirm "本当に削除してもよろしいですか？" do
            find(".destroy-user").click
          end
        end

        expect(page).to have_current_path(admin_users_path)
        expect(page).to have_content "ユーザを削除しました"
        expect(page).not_to have_content user.email
      end
    end

    context "一般ユーザがユーザ一覧画面にアクセスした場合" do
      before do
        visit new_session_path

        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: "password"

        click_button "ログイン"

        expect(page).to have_current_path(tasks_path)
      end

      it "タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される" do
        visit admin_users_path

        expect(page).to have_current_path(tasks_path)
        expect(page).to have_content "管理者以外アクセスできません"
      end
    end
  end
end