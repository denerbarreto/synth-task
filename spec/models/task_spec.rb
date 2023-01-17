require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:priority) }
    it { should validate_presence_of(:status) }
    it { should validate_inclusion_of(:status).in_array(["Em andamento", "Concluída", "Atrasada", "Cancelada"]) }
    it { belong_to(:user) }
    it { belong_to(:task_list) }
  end

  describe "task model factory tests" do
    it "create a valid task" do
      task = create(:task)
      expect(task).to be_valid
    end

    it "saves a task to the database" do
      task = build(:task)
      expect { task.save }.to change(Task, :count).by(1)
    end

    it "validates presence of name" do
      task = build(:task, name: nil)
      expect(task).to be_invalid
    end

    it "validates length of name" do
      task = build(:task, name: 'Ab')
      expect(task).to be_invalid
      
      task.name = 'A' * 51
      expect(task).to be_invalid
    end

    it "validates presence of description" do
      task = build(:task, description: nil)
      expect(task).to be_invalid
    end

    it "validates presence of status" do
      task = build(:task, status: nil)
      expect(task).to be_invalid
      
      valid_status = ["Em andamento", "Concluído", "Atrasada", "Cancelada"]
      task.status = valid_status[0]
      expect(valid_status).to include(task.status)
    end

    it "validates value of priority" do
      task = build(:task)
      expect(task).to be_valid

      task = build(:task, priority: nil)
      expect(task).to be_invalid
    end
  end
end
