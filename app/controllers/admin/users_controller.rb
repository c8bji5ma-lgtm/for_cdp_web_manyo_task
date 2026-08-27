class Admin::UsersController < ApplicationController
  before_action :require_admin
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.includes(:tasks)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: "ユーザを登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_users_path, notice: "ユーザを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      redirect_to admin_users_path, notice: "ユーザを削除しました"
    else
      redirect_to admin_users_path, alert: @user.errors.full_messages.join(", ")
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation,
      :admin
    )
  end
end