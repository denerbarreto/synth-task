require 'rails_helper'

RSpec.describe "Api::V1::Projects", type: :request do
  let(:user) { create(:user) }
  let(:credentials) { { email: user.email, password: user.password } }
  let(:auth_headers) { { "Authorization": "Bearer #{auth_token}" } }
  let(:auth_token) { response.headers["Authorization"].split(' ').last }
  let(:project_attributes) { attributes_for(:project) }

  before do
    post api_v1_sessions_path, params: { user: credentials }
  end

  describe "POST /api/v1/projects" do
    it "should create a project with valid data" do
      post api_v1_projects_path, headers: auth_headers, params: { project: project_attributes }

      expect(response).to have_http_status(201)
      expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
    end

    context "project with invalid data" do
      let(:project_attributes) { attributes_for(:project, name: nil) }
      
      it "should return status code 422" do
        post api_v1_projects_path, headers: auth_headers, params: { project: project_attributes }
  
        expect(response).to have_http_status(422)
        expect(response.headers["Content-Type"]).to eq("application/json; charset=utf-8")
      end
    end
  end 

  describe "GET /api/v1/projects" do
    let!(:projects) { create_list(:project, 3, user: user) }

    it "should return all project fo the current user" do
      get api_v1_projects_path, headers: auth_headers

      projects_list_data = response.parsed_body["projects"]
      projects_list_data.each do |project_list_data|
        expect(project_list_data["user"]["id"]).to eq(user.id)
      end
    end
  end

  describe "PATCH /api/v1/projects/:id" do
    let(:project) { create(:project, user: user) }
    let(:another_project) { create(:project) }

    it "should update project with valid data and current user" do
      patch api_v1_project_path(project), headers: auth_headers, params: { project: { "name": "New Name" } }
      
      expect(response).to have_http_status(200)
      expect(response.parsed_body["project"]["name"]).to eq("New Name")
    end

    it "should not update project with invalid data" do
      patch api_v1_project_path(project), headers: auth_headers, params: { project: { "name": "" } }

      expect(response).to have_http_status(422)
    end

    it "should not update project of another user" do
      patch api_v1_project_path(another_project), headers: auth_headers, params: { project: { "name": "New Name" } }

      expect(response).to have_http_status(401)
    end
  end

  describe "DELETE /api/v1/projects/:id" do
    let(:project) { create(:project, user: user) }
    let(:another_project) { create(:project) }

    it "should delete project of current user" do
      
      delete api_v1_project_path(project), headers: auth_headers

      expect(response).to have_http_status(200)
    end

    it "should not delete project of another user" do
      delete api_v1_project_path(another_project), headers: auth_headers

      expect(response).to have_http_status(401)
    end
  end

  describe "GET /api/v1/projects/:id" do
    let(:project) { create(:project, user: user) }
    let(:another_project) { create(:project) }

    it "should show project of current user" do
      
      get api_v1_project_path(project), headers: auth_headers

      expect(response).to have_http_status(200)
      expect(response.parsed_body["project"]["id"]).to eq(project.id)
      expect(response.parsed_body["project"]["name"]).to eq(project.name)
      expect(response.parsed_body["project"]["user"]["id"]).to eq(user.id)
    end

    it "should not show project of another user" do
      get api_v1_project_path(another_project), headers: auth_headers

      expect(response).to have_http_status(401)
    end
  end
end
