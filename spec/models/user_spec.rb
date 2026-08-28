require "rails_helper"

RSpec.describe "ユーザモデル機能", type: :model do
  describe "バリデーションのテスト" do
    context "ユーザの名前が空文字の場合" do
      it "バリデーションに失敗する" do
        user = FactoryBot.build(:user, name: "")

        expect(user).not_to be_valid
      end
    end

    context "ユーザのメールアドレスが空文字の場合" do
      it "バリデーションに失敗する" do
        user = FactoryBot.build(:user, email: "")

        expect(user).not_to be_valid
      end
    end

    context "ユーザのパスワードが空文字の場合" do
      it "バリデーションに失敗する" do
        user = FactoryBot.build(
          :user,
          password: "",
          password_confirmation: ""
        )

        expect(user).not_to be_valid
      end
    end

    context "ユーザのメールアドレスがすでに使用されていた場合" do
      it "バリデーションに失敗する" do
        FactoryBot.create(:user, email: "test@example.com")

        user = FactoryBot.build(
          :user,
          email: "TEST@example.com"
        )

        expect(user).not_to be_valid
      end
    end

    context "ユーザのパスワードが6文字未満の場合" do
      it "バリデーションに失敗する" do
        user = FactoryBot.build(
          :user,
          password: "12345",
          password_confirmation: "12345"
        )

        expect(user).not_to be_valid
      end
    end

    context "ユーザの名前に値があり、メールアドレスが使われていない値で、かつパスワードが6文字以上の場合" do
      it "バリデーションに成功する" do
        user = FactoryBot.build(
          :user,
          name: "テストユーザ",
          email: "valid@example.com",
          password: "password",
          password_confirmation: "password"
        )

        expect(user).to be_valid
      end
    end
  end
end