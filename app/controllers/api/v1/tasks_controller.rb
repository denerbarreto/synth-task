class Api::V1::TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :destroy] 
  before_action :authorize_user, only: [:show, :update, :destroy] 
  before_action :set_project_and_task_list, only: [:index, :create, :update, :destroy] 

  def index
    tasks = Task.where(user_id: current_user.id, task_list_id: @task_list.id)
  
    render json: tasks, status: :ok
  end

  def show
    task = @task
    render json: task, status: :ok
  end

  def create
    task = @task_list.tasks.build(task_params)
    task.user_id = current_user.id
    if task.save
      render json: task, status: :created
    else
      render json: { errors: task.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      render json: @task, status: :ok
    else
      render json: { errors: @task.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.destroy
      render json: { message: 'Task successfully deleted' }, status: :ok
    else
      render json: @taskt.errors, status: :unprocessable_entity
    end
  end

  private

  def set_project_and_task_list
    @project = Project.find_by(id: params[:project_id], user_id: current_user.id)
    if @project.nil?
      render json: { error: "Project not found or does not belong to current user" }, status: :not_found
      return
    end

    @task_list = TaskList.find_by(id: params[:task_list_id], project_id: @project.id)
    if @task_list.nil?
      render json: { error: "Task list not found or does not belong to specified project" }, status: :not_found
      return
    end
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def authorize_user
    unless @task.user_id == current_user.id
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  def task_params
    params.require(:task).permit(:name, :description, :date_start, :date_end, :status, :priority)
  end
end
