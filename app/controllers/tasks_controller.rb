class TasksController < ApplicationController

  def index
    @tasks = Task.all

    if params[:search].present?
      if params[:search][:title].present?
        @tasks = @tasks.search_title(params[:search][:title])
      end

      if params[:search][:status].present?
        @tasks = @tasks.search_status(params[:search][:status])
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
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: I18n.t("flash.tasks.create")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      redirect_to task_path(@task), notice: I18n.t("flash.tasks.update")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to tasks_path, notice: I18n.t("flash.tasks.destroy")
  end

  private

  def task_params
    params.require(:task).permit(
      :title,
      :content,
      :deadline_on,
      :priority,
      :status
    )
  end
end