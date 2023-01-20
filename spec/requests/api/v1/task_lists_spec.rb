require 'rails_helper'

RSpec.describe "Api::V1::TaskLists", type: :request do

    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:credentials) { { email: user.email, password: user.password } }
    let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
    let(:auth_token) { response.headers["Authorization"].split(' ').last }
    let(:task_list) { create(:task_list, user: user) }
    let(:another_task_list) { create(:task_list) }
    let(:task_list_attributes) { attributes_for(:task_list) }
  
    before do
      post api_v1_sessions_path, params: { user: credentials }
    end

    describe "POST /api/v1/:project_id/task_lists" do
      it "should create task_list with valid data" do
        post api_v1_project_task_lists_path(project), headers: auth_headers, params: { task_list: task_list_attributes }
    
        expect(response).to have_http_status(201)
        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
      end
      
      context "task_list with invalid data" do
        let(:task_list_attributes) { attributes_for(:task_list, name: nil) }
        
        it "should return status code 422" do
          post api_v1_project_task_lists_path(project), headers: auth_headers, params: { task_list: task_list_attributes }
    
          expect(response).to have_http_status(422)
          expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
        end
      end
    end

    describe "GET /api/v1/:project_id/task_lists" do
      let!(:task_lists) { create_list(:task_list, 3, user: user, project: project) }
  
      it "should return only task_lists of the current user" do
        get api_v1_project_task_lists_path(project), headers: auth_headers
      
        task_lists_data = response.parsed_body["task_lists"]
        task_lists_data.each do |task_list_data|
          expect(task_list_data["user"]["id"]).to eq(user.id)
        end
      end
    end

    describe "PATCH /api/v1/:project_id/task_lists/:id" do
      let(:another_task_list) { create(:task_list) }
  
      it "should update task_list with valid data and current user" do
        patch api_v1_project_task_list_path(project, task_list), headers: auth_headers, params: { task_list: { "name": "New Name" } }
  
        expect(response).to have_http_status(200)
        expect(response.parsed_body["task_list"]["name"]).to eq("New Name")
      end
  
      it "should not update task_list with invalid data" do
        patch api_v1_project_task_list_path(project, task_list), headers: auth_headers, params: { task_list: { "name": "" } }
  
        expect(response).to have_http_status(422)
      end
  
      it "should not update task_list of another user" do
        patch api_v1_project_task_list_path(project, another_task_list), headers: auth_headers, params: { task_list:  { "name": "New Name" } }
  
        expect(response).to have_http_status(401)
      end
    end

    describe "DELETE /api/v1/:project_id/task_lists/:id" do
      it "should delete task_list of current user" do
        delete api_v1_project_task_list_path(project, task_list), headers: auth_headers
  
        expect(response).to have_http_status(200)
      end
  
      it "should not delete task_list of another user" do
        patch api_v1_project_task_list_path(project, another_task_list), headers: auth_headers
  
        expect(response).to have_http_status(401)
      end
    end

    describe "GET /api/v1/:project_id/task_lists/:id" do
      it "should show task_list of current user" do
        
        get api_v1_project_task_list_path(project, task_list), headers: auth_headers
  
        expect(response).to have_http_status(200)
        expect(response.parsed_body['task_list']['id']).to eq(task_list.id)
        expect(response.parsed_body['task_list']['name']).to eq(task_list.name)
        expect(response.parsed_body['task_list']['order']).to eq(task_list.order)
        expect(response.parsed_body['task_list']["user"]["id"]).to eq(user.id)
      end
  
      it "should not show task_list of another user" do
        get api_v1_project_task_list_path(project, another_task_list), headers: auth_headers
  
        expect(response).to have_http_status(401)
      end
    end

    describe 'associations' do
      let(:task_list){create(:task_list)}
      context "task_list has many tasks" do
        let(:task){create(:task, task_list: task_list)}
        it "should expect a list of task" do
          expect(task_list.tasks).to eq([task])
        end
      end
    end
end