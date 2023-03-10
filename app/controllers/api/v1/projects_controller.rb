class Api::V1::ProjectsController < ApplicationController
  before_action :set_task_list, only: [:update, :destroy, :show] 
  before_action :authorize_user, only: [:update, :destroy, :show] 

  def index
    projects = Project.where(user_id: current_user.id)
    render json: projects, each_serializer: ProjectSerializer
  end

  def show
    project = @project
    render json: project, status: :ok
  end

  def create
    project = Project.new(project_params)
    project.user_id = current_user.id
    if project.save
      render json: project, status: :created
    else
      render json: project.errors, status: :unprocessable_entity
    end
  end

  def update
    if @project.update(project_params)
      render json: @project, status: :ok
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @project.destroy
      render json: { message: 'Task list successfully deleted' }, status: :ok
    else
      render json: @project.errors, status: :unprocessable_entity
    end
  end

  private

  def set_task_list
    @project = Project.find(params[:id])
  end

  def authorize_user
    unless @project.user_id == current_user.id
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  def project_params
    params.require(:project).permit(:name)
  end
end
