require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do
  let(:user) { create(:user) }
  let(:credentials) { { email: user.email, password: user.password } }
  let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
  let(:auth_token) { response.headers["Authorization"].split(' ').last }
  let(:project_attributes) { attributes_for(:project) }

  before do
    post api_v1_sessions_path, params: {
      "data": {
        "type": :user,
        "attributes": credentials
      }
    }
  end

  describe "POST /api/v1/projects" do
    it "should create a project with valid data" do
      post api_v1_projects_path, headers: auth_headers, params: {
        "data": {
          "type": :project,
          "attributes": project_attributes
        },
        "relationships": {
          "user":{
            "data": {
              "type": :user,
              "id": "#{user.id}",
            }
          }
        }
      }
    
      expect(response).to have_http_status(201)
      expect(response.headers["Content-Type"]).to eq("application/vnd.api+json; charset=utf-8")
    end

    context "project with invalid data" do
      let(:project_attributes) { attributes_for(:project, name: nil) }
      
      it "should return status code 422" do
        post api_v1_projects_path, headers: auth_headers, params: {
          "data": {
            "type": :project,
            "attributes": project_attributes
          },
          "relationships": {
            "user":{
              "data": {
                "type": :user,
                "id": "#{user.id}",
              }
            }
          }
        }
  
        expect(response).to have_http_status(422)
        expect(response.headers["Content-Type"]).to eq("application/vnd.api+json; charset=utf-8")
      end
    end
  end 
end
