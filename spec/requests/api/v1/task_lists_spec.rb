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

  describe "GET /api/v1/task_lists" do
    let!(:task_lists) { create_list(:task_list, 3, user: user) }
    let(:another_user) { create(:user) }

    it "should return all task_lists in JSON API format" do
      get api_v1_task_lists_path, headers: auth_headers
  
      expect(response).to have_http_status(200)
      expect(response.headers["Content-Type"]).to eq("application/vnd.api+json; charset=utf-8")
  
      json_response = response.parsed_body
      expect(json_response).to have_key("data")
      expect(json_response["data"]).to be_an(Array)
  
      json_response["data"].each do |task_list|
        expect(task_list).to have_key("id")
        expect(task_list).to have_key("type")
        expect(task_list).to have_key("attributes")
        expect(task_list).to have_key("relationships")
        expect(task_list["attributes"]).to have_key("name")
        expect(task_list["attributes"]).to have_key("order")
        expect(task_list["relationships"]["user"]["data"]).to have_key("id")
      end
    end

    it "should return only task_lists of the current user" do
      get api_v1_task_lists_path, headers: auth_headers
    
      task_lists_data = response.parsed_body["data"]
      task_lists_data.each do |task_list_data|
        expect(task_list_data["relationships"]["user"]["data"]["id"]).to eq(user.id.to_s)
      end
    end
  end

  describe "PATCH /api/v1/task_lists/:id" do
    let(:task_list) { create(:task_list, user: user) }
    let(:another_task_list) { create(:task_list) }

    it "should update task_list with valid data and current user" do
      patch api_v1_task_list_path(task_list), headers: auth_headers, params: {
        "data": {
          "type": :task_list,
          "attributes": { "name": "New Name" }
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

      expect(response).to have_http_status(200)
      expect(response.parsed_body["data"]["attributes"]["name"]).to eq("New Name")
    end

    it "should not update task_list with invalid data" do
      patch api_v1_task_list_path(task_list), headers: auth_headers, params: {
        "data": {
          "type": :task_list,
          "attributes": { "name": "" }
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
    end

    it "should not update task_list of another user" do
      patch api_v1_task_list_path(another_task_list), headers: auth_headers, params: {
        "data": {
          "type": :task_list,
          "attributes": { "name": "New Name" }
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

      expect(response).to have_http_status(401)
    end
  end
end