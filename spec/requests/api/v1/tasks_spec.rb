require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:credentials) { { email: user.email, password: user.password } }
  let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
  let(:auth_token) { response.headers["Authorization"].split(' ').last }
  let(:task_list) { create(:task_list, user: user, project: project) }
  let(:task) { create(:task, user: user, task_list: task_list) }
  let(:task_attributes) { attributes_for(:task) }

  before do
    post api_v1_sessions_path, params: { user: credentials }
  end

  describe "POST api/v1/projects/:project_id/task_lists/:task_list_id/tasks" do
    it "should create task with valid data" do
      post api_v1_project_task_list_tasks_path(project, task_list), headers: auth_headers, params: { task: task_attributes }

      expect(response).to have_http_status(201)
      expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
    end

    context "task with invalid data" do
      let(:task_attributes) { attributes_for(:task, name: nil) }
      
      it "should return status code 422" do
        post api_v1_project_task_list_tasks_path(project, task_list), headers: auth_headers, params: { task: task_attributes }
  
        expect(response).to have_http_status(422)
        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
      end
    end

    describe "GET /api/v1/:project_id/task_lists/:task_list_id/tasks" do
      let!(:task) { create_list(:task, 3, user: user, task_list: task_list) }
  
      it "should return only task of the current user" do
        get api_v1_project_task_list_tasks_path(project, task_list), headers: auth_headers
      
        task_data = response.parsed_body["tasks"]
        task_data.each do |task_data|
          expect(task_data["user"]["id"]).to eq(user.id)
        end
      end
    end

    describe "PATCH /api/v1/:project_id/task_lists/:task_list_id/tasks/:task_id" do
      let(:another_task) { create(:task) }
  
      it "should update task with valid data and current user" do
        patch api_v1_project_task_list_task_path(project, task_list, task), headers: auth_headers, params: { task: { "name": "New Name" } }

        expect(response).to have_http_status(200)
        expect(response.parsed_body["task"]["name"]).to eq("New Name")
      end
  
      it "should not update task with invalid data" do
        patch api_v1_project_task_list_task_path(project, task_list, task), headers: auth_headers, params: { task: { "name": "" } }
  
        expect(response).to have_http_status(422)
      end
  
      it "should not update task of another user" do
        patch api_v1_project_task_list_task_path(project, task_list, another_task), headers: auth_headers, params: { task:  { "name": "New Name" } }
  
        expect(response).to have_http_status(401)
      end
    end

  end
end
