class Api::V1::TaskListsController < ApplicationController
  before_action :set_task_list, only: [:show, :update, :destroy] 
  before_action :authorize_user, only: [:show, :update, :destroy] 

  def index
    task_lists = TaskList.where(user_id: current_user.id)
    render json: task_lists, each_serializer: TaskListSerializer
  end

  def show
    task_list = @task_list
    render json: task_list, status: :ok
  end
  
  def create
    task_list = TaskList.new(task_list_params)
    task_list.user_id = current_user.id
    task_list.project_id = params[:relationships][:project][:data][:id]
    if task_list.save
      render json: task_list, status: :created
    else
      render json: task_list.errors, status: :unprocessable_entity
    end
  end

  def update
    if @task_list.update(task_list_params)
      render json: @task_list, status: :ok
    else
      render json: @task_list.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @task_list.destroy
      render json: { message: 'Task list successfully deleted' }, status: :ok
    else
      render json: @task_list.errors, status: :unprocessable_entity
    end
  end

  private

  def set_task_list
    @task_list = TaskList.find(params[:id])
  end

  def authorize_user
    unless @task_list.user_id == current_user.id
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  def task_list_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
