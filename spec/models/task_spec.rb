require "rails_helper"

RSpec.describe "タスクモデル機能", type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe "バリデーションのテスト" do
    context "タスクのタイトルが空文字の場合" do
      it "バリデーションに失敗する" do
        task = Task.create(
          title: "",
          content: "企画書を作成する。",
          deadline_on: Date.current,
          priority: "中",
          status: "未着手",
          user: user
        )

        expect(task).not_to be_valid
      end
    end

    context "タスクの説明が空文字の場合" do
      it "バリデーションに失敗する" do
        task = Task.create(
          title: "書類作成",
          content: "",
          deadline_on: Date.current,
          priority: "中",
          status: "未着手",
          user: user
        )

        expect(task).not_to be_valid
      end
    end

    context "タスクの必須項目に値が入っている場合" do
      it "タスクを登録できる" do
        task = Task.create(
          title: "書類作成",
          content: "企画書を作成する。",
          deadline_on: Date.current,
          priority: "中",
          status: "未着手",
          user: user
        )

        expect(task).to be_valid
      end
    end

    context "タスクの終了期限が空の場合" do
      it "バリデーションに失敗する" do
        task = Task.create(
          title: "書類作成",
          content: "企画書を作成する。",
          deadline_on: nil,
          priority: "中",
          status: "未着手",
          user: user
        )

        expect(task).not_to be_valid
      end
    end

    context "タスクの優先度が空の場合" do
      it "バリデーションに失敗する" do
        task = Task.create(
          title: "書類作成",
          content: "企画書を作成する。",
          deadline_on: Date.current,
          priority: nil,
          status: "未着手",
          user: user
        )

        expect(task).not_to be_valid
      end
    end

    context "タスクのステータスが空の場合" do
      it "バリデーションに失敗する" do
        task = Task.create(
          title: "書類作成",
          content: "企画書を作成する。",
          deadline_on: Date.current,
          priority: "中",
          status: nil,
          user: user
        )

        expect(task).not_to be_valid
      end
    end
  end

  describe "検索機能" do
    let(:search_user) { FactoryBot.create(:user) }

    let!(:first_task) do
      FactoryBot.create(
        :task,
        user: search_user
      )
    end

    let!(:second_task) do
      FactoryBot.create(
        :second_task,
        user: search_user
      )
    end

    let!(:third_task) do
      FactoryBot.create(
        :third_task,
        user: search_user
      )
    end

    context "scopeメソッドでタイトルのあいまい検索をした場合" do
      it "検索ワードを含むタスクが絞り込まれる" do
        tasks = search_user.tasks.search_title("first")

        expect(tasks).to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks).not_to include(third_task)
        expect(tasks.count).to eq 1
      end
    end

    context "scopeメソッドでステータス検索をした場合" do
      it "ステータスに完全一致するタスクが絞り込まれる" do
        tasks = search_user.tasks.search_status("完了")

        expect(tasks).to include(third_task)
        expect(tasks).not_to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks.count).to eq 1
      end
    end

    context "scopeメソッドでタイトルのあいまい検索とステータス検索をした場合" do
      it "検索ワードをタイトルに含み、かつステータスに完全一致するタスクが絞り込まれる" do
        tasks =
          search_user.tasks
                     .search_title("third")
                     .search_status("完了")

        expect(tasks).to include(third_task)
        expect(tasks).not_to include(first_task)
        expect(tasks).not_to include(second_task)
        expect(tasks.count).to eq 1
      end
    end
  end
end