class Api::V1::TasksController < ApplicationController

  def create
    project = Project.find(params[:project_id])
    task_list = TaskList.find(params[:task_list_id])
    if project.user == current_user && task_list.user == current_user
      task = task_list.tasks.build(task_params)
      task.user = current_user
      if task.save
        render json: task, status: :created
      else
        render json: task.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
  

  private

  def task_params
    params.require(:task).permit(:name, :description, :date_start, :date_end, :status, :priority)
  end
end
