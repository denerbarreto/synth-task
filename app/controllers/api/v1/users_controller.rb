class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  
  def create
    user = User.new(user_params)
    if user.save
      render json: user, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    if current_user.update(user_params)
      render json: current_user
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end
  
  private

  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end