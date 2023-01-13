require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST /api/v1/users" do
    context "user with valid data" do
      let(:user_attributes) { attributes_for(:user) }
  
      it "should return status code 201 and the new user data" do
        post api_v1_users_path, params: {
          "data": {
            "type": :user,
            "attributes": user_attributes
          }
        }
  
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
        post api_v1_users_path, params: {
          "data": {
            "type": :user,
            "attributes": user_attributes
          }
        }
  
        expect(response).to have_http_status(422)
        expect(response.headers["Content-Type"]).to eq("application/vnd.api+json; charset=utf-8")
        expect(response.headers["Location"]).to be_nil
      end
    end
  end

  describe "PATCH /api/v1/users" do
    let(:user) { create(:user) }
    let(:credentials) { { email: user.email, password: user.password } }
    let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
    let(:auth_token) { response.headers["Authorization"].split(' ').last }

    before do
      post api_v1_sessions_path, params: {
        "data": {
          "type": :user,
          "attributes": credentials
        }
      }
    end

    it "allows the user to update their name" do
      patch api_v1_user_path(user), headers: auth_headers, params: {
        "data": {
          "type": :user,
          "attributes": { "name": "New Name" }
        }
      }

      expect(response).to have_http_status(200)
      expect(response.parsed_body["data"]["attributes"]["name"]).to eq("New Name")
    end

    it "allows the user to update their password" do
      patch api_v1_user_path(user), headers: auth_headers, params: {
        "data": {
          "type": :user,
          "attributes": { "password": "NewPassWord", "password_confirmation": "NewPassWord" }
        }
      }

      expect(response).to have_http_status(200)
      expect(response.parsed_body["data"]["attributes"]["tokens"]).not_to be_empty
    end

    it "returns an error when the user attempts to update with an invalid token" do
      patch api_v1_user_path(user), headers: { "Authorization": "Bearer invalid_token" }, params: {
        "data": {
          "type": :user,
          "attributes": { "name": "New Name" }
        }
      }
    
      expect(response).to have_http_status(401)
      expect(response.parsed_body["error"]).not_to be_empty
    end
    
    
    it "does not update the user's password if the password confirmation is not provided" do
      patch api_v1_user_path(user), headers: auth_headers, params: {
        "data": {
          "type": :user,
          "attributes": { "password": "NewPassWord" }
        }
      }
    
      expect(response).to have_http_status(422)
    end

    it "returns an error when the user attempts to update with an expired token" do
      Timecop.travel(Time.now + 7.days)
      patch api_v1_user_path(user), headers: auth_headers, params: {
        "data": {
          "type": :user,
          "attributes": { "name": "New Name" }
        }
      }

      Timecop.return
      expect(response).to have_http_status(401)
      expect(response.parsed_body["error"]).to eq("Token is invalid")
    end
  end   

  describe "DELETE /api/v1/users/:id" do
    let(:user) { create(:user) }
    let(:credentials) { { email: user.email, password: user.password } }
    let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
    let(:auth_token) { response.headers["Authorization"].split(' ').last }

    before do
      post api_v1_sessions_path, params: {
        "data": {
          "type": :user,
          "attributes": credentials
        }
      }
    end

    it "allows the user to delete their account" do
      delete api_v1_user_path(user), headers: auth_headers, params: {
        "data": {
          "type": :user,
          "attributes": { "id": "#{user.id}" }
        }
      }

      expect(response).to have_http_status(200)
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end