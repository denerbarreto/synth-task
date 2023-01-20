class Api::V1::TasksController < ApplicationController

  def index
    project = Project.find_by(id: params[:project_id], user_id: current_user.id)
    if project.nil?
      render json: { error: "Project not found or does not belong to current user" }, status: :not_found
      return
    end
    
    task_list = TaskList.find_by(id: params[:task_list_id], project_id: project.id)
    if task_list.nil?
      render json: { error: "Task list not found or does not belong to specified project" }, status: :not_found
      return
    end
  
    tasks = Task.where(user_id: current_user.id, task_list_id: task_list.id)
  
    render json: tasks, status: :ok
  end

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
