require 'rails_helper'

RSpec.describe "Api::V1::TaskLists", type: :request do
  let(:user) { create(:user) }
  let(:credentials) { { email: user.email, password: user.password } }
  let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
  let(:auth_token) { response.headers["Authorization"].split(' ').last }
  let(:task_list_attributes) { attributes_for(:task_list) }

  before do
    post api_v1_sessions_path, params: {
      "data": {
        "type": :user,
        "attributes": credentials
      }
    }
  end

  describe "POST /api/v1/task_lists" do
    it "should create task_list with valid data" do
      post api_v1_task_lists_path, headers: auth_headers, params: {
        "data": {
          "type": :task_list,
          "attributes": task_list_attributes
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
    
    context "task_list with invalid data" do
      let(:task_list_attributes) { attributes_for(:task_list, name: nil) }
      
      it "should return status code 422" do
        post api_v1_task_lists_path, headers: auth_headers, params: {
          "data": {
            "type": :task_list,
            "attributes": task_list_attributes
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
