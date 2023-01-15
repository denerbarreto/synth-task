class Api::V1::ProjectsController < ApplicationController

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

  private

  def project_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
