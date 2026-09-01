class LabelsController < ApplicationController
  before_action :require_login
  before_action :set_label, only: [:edit, :update, :destroy]

  def index
    @labels = current_user.labels
  end

  def new
    @label = current_user.labels.build
  end

  def create
    @label = current_user.labels.build(label_params)

    if @label.save
      redirect_to labels_path, notice: "ラベルを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to labels_path, notice: "ラベルを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @label.destroy

    redirect_to labels_path, notice: "ラベルを削除しました"
  end

  private

  def set_label
    @label = current_user.labels.find_by(id: params[:id])

    return if @label.present?

    redirect_to labels_path, alert: "アクセス権限がありません"
  end

  def label_params
    params.require(:label).permit(:name)
  end
end