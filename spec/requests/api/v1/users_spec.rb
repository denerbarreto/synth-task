require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do
    context "user with valid data" do
      let(:user_attributes) { attributes_for(:user) }
  
      it "should return status code 201 and the new user data" do
        post api_v1_users_path, params: { user: user_attributes }
  
        expect(response).to have_http_status(201)
        expect(response.headers["Content-Type"]).to eq("application/vnd.api+json; charset=utf-8")

        user_response = JSON.parse(response.body)
        expect(user_response["data"]["id"]).to be_present
        expect(user_response["data"]["attributes"]["name"]).to eq(user_attributes[:name])
        expect(user_response["data"]["attributes"]["email"]).to eq(user_attributes[:email])
      end
    end
  
    context "user with invalid data" do
      let(:user_attributes) { attributes_for(:user, name: nil) }
  
      it "should return status code 422" do
        post api_v1_users_path, params: { user: user_attributes }
  
        expect(response).to have_http_status(422)
        expect(response.headers["Content-Type"]).to eq("application/vnd.api+json; charset=utf-8")
        expect(response.headers["Location"]).to be_nil
      end
    end
  end
end