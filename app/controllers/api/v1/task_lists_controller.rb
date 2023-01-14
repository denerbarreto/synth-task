class Api::V1::TaskListsController < ApplicationController
  
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

  private

  def task_list_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
