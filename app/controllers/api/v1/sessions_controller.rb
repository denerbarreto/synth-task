class Api::V1::SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  
  def create
    user = User.find_by(email: session_params[:email])
  
    if user && user.authenticate(session_params[:password])
      token = user.generate_auth_token
      response.headers['Authorization'] = "Bearer #{token}"
      render json: user
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    current_user.invalidate_auth_token(request.headers['Authorization'].split(' ').last)
    head :ok
  end
  
  private

  def session_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end