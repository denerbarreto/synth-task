class Api::V1::ProjectsController < ApplicationController
  before_action :set_task_list, only: [:update] 
  before_action :authorize_user, only: [:update] 

  def index
    projects = Project.where(user_id: current_user.id)
    render json: projects, each_serializer: ProjectSerializer
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
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
