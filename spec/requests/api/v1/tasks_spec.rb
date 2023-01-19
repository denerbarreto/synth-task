require 'rails_helper'

RSpec.describe "Api::V1::Tasks", type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:credentials) { { email: user.email, password: user.password } }
  let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
  let(:auth_token) { response.headers["Authorization"].split(' ').last }
  let(:task_list) { create(:task_list, user: user) }
  let(:task) { create(:task, project: project, task_list: task_list) }
  let(:task_attributes) { attributes_for(:task) }

  before do
    post api_v1_sessions_path, params: { user: credentials }
  end

  describe "POST api/v1/projects/:project_id/task_lists/:task_list_id/tasks" do
    it "should create task_list with valid data" do
      post api_v1_project_task_list_tasks_path(project, task_list), headers: auth_headers, params: { task: task_attributes}

      p response.parsed_body
      expect(response).to have_http_status(201)
      expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
    end
  end
end
