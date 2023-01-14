class Api::V1::TaskListsController < ApplicationController
  before_action :set_task_list, only: [:update] 
  before_action :authorize_user, only: [:update] 

  def index
    task_lists = TaskList.where(user_id: current_user.id)
    render json: task_lists, each_serializer: TaskListSerializer
  end
  
  def create
    task_list = TaskList.new(task_list_params)
    task_list.user_id = current_user.id
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
