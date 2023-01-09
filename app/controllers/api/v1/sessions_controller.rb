class Api::V1::SessionsController < ApplicationController
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
  
  private

  def session_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end