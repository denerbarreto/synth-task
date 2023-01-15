require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
    it { should belong_to(:user) }
    it { should have_many(:task_lists) }
  end

  describe "project model factory tests" do
    it "creates a valid project" do
      project = create(:project)
      expect(project). to be_valid
    end

    it "saves a project to the database" do
      project = build(:project)
      expect { project.save }.to change(Project, :count).by(1)
    end

    it "validates presence of name" do
      project = build(:project, name: nil)
      expect(project).to be_invalid
    end

    it "validates length of name" do
      project = build(:project, name: 'Ab')
      expect(project).to be_invalid
      
      project.name = 'A' * 51
      expect(project).to be_invalid
    end
  end

  describe 'associations' do
    let(:project){create(:project)}
    context "project has many task_list" do
      let(:task_list){create(:task_list, project: project)}
      it "should expect a list of task_lists" do
        expect(project.task_lists).to eq([task_list])
      end
    end
  end
end
