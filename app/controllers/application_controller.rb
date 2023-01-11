class ApplicationController < ActionController::API
  include ActionController::Helpers
  
  before_action :authenticate_request
  helper_method :current_user

  def current_user
    @current_user
  end

  private 

  def authenticate_request
    if request.headers['Authorization'].present?
      token = request.headers['Authorization'].split(' ').last
      begin
        user = User.authenticate(token)
        if user
          @current_user = user
        else
          render json: { error: 'Token is invalid' }, status: :unauthorized
        end
      rescue JWT::DecodeError => e
        render json: { error: 'Token is invalid' }, status: :unauthorized
      end
    else
      render json: { error: 'Token is missing' }, status: :unauthorized
    end
  end  
end