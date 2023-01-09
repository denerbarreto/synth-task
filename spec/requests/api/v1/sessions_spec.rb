require 'rails_helper'

RSpec.describe "Api::V1::Sessions", type: :request do
  describe "POST /api/v1/sessions" do
    context "with valid credentials" do
      let(:user) { create(:user) }
      let(:credentials) { { email: user.email, password: user.password } }
    
      it "returns a status code of 200" do
        post api_v1_sessions_path, params: {
          "data": {
            "type": :user,
            "attributes": credentials
          }
        }
        expect(response).to have_http_status(200)
        expect(response.headers["Content-Type"]).to eq("application/vnd.api+json; charset=utf-8")
      end
    
      it "sets the Authorization header" do
        post api_v1_sessions_path, params: {
          "data": {
            "type": :user,
            "attributes": credentials
          }
        }
        expect(response.headers["Authorization"]).to be_present
      end
    
      it "returns the user data" do
        post api_v1_sessions_path, params: {
          "data": {
            "type": :user,
            "attributes": credentials
          }
        }
        token = response.headers["Authorization"].split(" ").last
        user = User.authenticate(token)
        expect(user).to eq(User.find(user.id))
      end
    end
  
    context "with invalid credentials" do
      let(:credentials) { { email: "invalid@email.com", password: "invalidpassword" } }
  
      it "returns a 401 status code" do
        post api_v1_sessions_path, params: {
          "data": {
            "type": :user,
            "attributes": credentials
          }
        }
  
        expect(response).to have_http_status(401)
        expect(response.headers["Content-Type"]).to eq("application/vnd.api+json; charset=utf-8")
      end
    end
  end
end