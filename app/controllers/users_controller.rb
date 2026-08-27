class UsersController < ApplicationController
  before_action :require_logout, only: [:new, :create]
  before_action :require_login, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params.merge(admin: false))

    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: "アカウントを登録しました"
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
      redirect_to user_path(@user), notice: "アカウントを更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    return if @user == current_user

    redirect_to tasks_path, alert: "アクセス権限がありません"
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end
end