class Api::V1::UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def show
    if current_user.id != params[:id].to_i
      render json: {error: "Unauthorized"}, status: 401
    else
      render json: current_user, status: :ok
    end
  end
  
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

  def destroy
    if current_user.destroy
      render json: { message: 'User account successfully deleted' }, status: :ok
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end
  
  private

  def user_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end