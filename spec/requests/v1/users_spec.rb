require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:user) { create(:user) }
  let(:credentials) { { email: user.email, password: user.password } }
  let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
  let(:auth_token) { response.headers["Authorization"].split(' ').last }

  before do
    post api_v1_sessions_path, params: { user: credentials }
  end

  describe "POST /api/v1/users" do
    context "user with valid data" do
      let(:user_attributes) { attributes_for(:user) }
  
      it "should return status code 201 and the new user data" do
        post api_v1_users_path, params: { user: user_attributes }
  
        expect(response).to have_http_status(201)
        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")

        user_response = JSON.parse(response.body)
        expect(user_response["user"]["id"]).to be_present
        expect(user_response["user"]["name"]).to eq(user_attributes[:name])
        expect(user_response["user"]["email"]).to eq(user_attributes[:email])
      end
    end
  
    context "user with invalid data" do
      let(:user_attributes) { attributes_for(:user, name: nil) }
  
      it "should return status code 422" do
        post api_v1_users_path, params: { user: user_attributes }

        expect(response).to have_http_status(422)
        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "PATCH /api/v1/users" do
    it "allows the user to update their name" do
      patch api_v1_user_path(user), headers: auth_headers, params: { user: {"name": "New Name"} }

      expect(response).to have_http_status(200)
      expect(response.parsed_body["user"]["name"]).to eq("New Name")
    end

    it "allows the user to update their password" do
      patch api_v1_user_path(user), headers: auth_headers, params: { user: {"password": "NewPassWord", "password_confirmation": "NewPassWord"} }

      expect(response).to have_http_status(200)
      expect(response.parsed_body["user"]["tokens"]).not_to be_empty
    end

    it "returns an error when the user attempts to update with an invalid token" do
      patch api_v1_user_path(user), headers: { "Authorization": "Bearer invalid_token" }, params: { user: {"name": "New Name"} }
    
      expect(response).to have_http_status(401)
      expect(response.parsed_body["error"]).not_to be_empty
    end
    
    
    it "does not update the user's password if the password confirmation is not provided" do
      patch api_v1_user_path(user), headers: auth_headers, params: { user: {"password": "NewPassWord"} }
    
      expect(response).to have_http_status(422)
    end

    it "returns an error when the user attempts to update with an expired token" do
      Timecop.travel(Time.now + 7.days)
      patch api_v1_user_path(user), headers: auth_headers, params: { user: {"name": "New Name"} }

      Timecop.return
      expect(response).to have_http_status(401)
      expect(response.parsed_body["error"]).to eq("Token is invalid")
    end
  end   

  describe "DELETE /api/v1/users/:id" do
    it "allows the user to delete their account" do
      delete api_v1_user_path(user), headers: auth_headers

      expect(response).to have_http_status(200)
      expect(User.find_by(id: user.id)).to be_nil
    end
  end

  describe "GET /api/v1/users/:id" do
    it "allows the user to view their account details" do
      get api_v1_user_path(user), headers: auth_headers

      expect(response).to have_http_status(200)
      expect(response.parsed_body['user']['name']).to eq(user.name)
      expect(response.parsed_body['user']['email']).to eq(user.email)
      expect(response.parsed_body['user']['id']).to eq(user.id)
    end

    it "does not allow an unauthenticated user to view another user's account details" do
      get api_v1_user_path(user)

      expect(response).to have_http_status(401)
    end

    it "does not allow an authenticated user with a different ID to view another user's account details" do
      other_user = create(:user)
      get api_v1_user_path(other_user), headers: auth_headers

      expect(response).to have_http_status(401)
    end
  end
end