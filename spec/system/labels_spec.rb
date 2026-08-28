require "rails_helper"

RSpec.describe "ラベル管理機能", type: :system do
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

    context "ラベルを登録した場合" do
      it "登録したラベルが表示される" do
        find("#new-label").click

        fill_in "名前", with: "仕事"

        click_button "登録する"

        expect(page).to have_current_path(labels_path)
        expect(page).to have_content "仕事"
        expect(page).to have_content "ラベルを登録しました"
      end
    end
  end

  describe "一覧表示機能" do
    let!(:first_label) do
      FactoryBot.create(
        :label,
        user: user,
        name: "仕事"
      )
    end

    let!(:second_label) do
      FactoryBot.create(
        :label,
        user: user,
        name: "勉強"
      )
    end

    before do
      login_as(user)
      find("#labels-index").click
    end

    context "一覧画面に遷移した場合" do
      it "登録済みのラベル一覧が表示される" do
        expect(page).to have_content "仕事"
        expect(page).to have_content "勉強"
      end
    end
  end
end