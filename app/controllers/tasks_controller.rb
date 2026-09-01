class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks

    if params[:search].present?
      if params[:search][:title].present?
        @tasks = @tasks.search_title(params[:search][:title])
      end

      if params[:search][:status].present?
        @tasks = @tasks.search_status(params[:search][:status])
      end

      if params[:search][:label].present?
        label = current_user.labels.find_by(id: params[:search][:label])

        @tasks =
          if label.present?
            @tasks.where(id: label.tasks.select(:id))
          else
            @tasks.none
          end
      end
    end

    @tasks =
      if params[:sort_deadline_on]
        @tasks.sort_deadline_on
      elsif params[:sort_priority]
        @tasks.sort_priority
      else
        @tasks.recent
      end

    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to tasks_path, notice: I18n.t("flash.tasks.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: I18n.t("flash.tasks.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy

    redirect_to tasks_path, notice: I18n.t("flash.tasks.destroy")
  end

  private

  def set_task
    @task = current_user.tasks.find_by(id: params[:id])

    return if @task.present?

    redirect_to tasks_path, alert: "アクセス権限がありません"
  end

  def task_params
    permitted_params = params.require(:task).permit(
      :title,
      :content,
      :deadline_on,
      :priority,
      :status,
      label_ids: []
    )

    permitted_params[:label_ids] =
      current_user.labels.where(
        id: permitted_params[:label_ids] || []
      ).pluck(:id)

    permitted_params
  end
end