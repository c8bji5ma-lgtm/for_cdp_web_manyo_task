class TasksController < ApplicationController

  def index
    @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
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
    params.require(:task).permit(:title, :content)
  end
end