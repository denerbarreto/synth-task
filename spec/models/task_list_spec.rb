require 'rails_helper'

RSpec.describe TaskList, type: :model do
  describe "Validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
    it { should validate_presence_of(:order) }
    it { should validate_numericality_of(:order).only_integer }
    it { should belong_to(:user) }
  end

  describe "task_list model factory tests" do
    it "creates a valid task_list" do
      task_list = create(:task_list)
      expect(task_list). to be_valid
    end

    it "saves a task_list to the database" do
      task_list = build(:task_list)
      expect { task_list.save }.to change(TaskList, :count).by(1)
    end

    it "validates presence of name" do
      task_list = build(:task_list, name: nil)
      expect(task_list).to be_invalid
    end

    it "validates length of name" do
      task_list = build(:task_list, name: 'Ab')
      expect(task_list).to be_invalid
      
      task_list.name = 'A' * 51
      expect(task_list).to be_invalid
    end

    it "validates presence of order" do
      task_list = build(:task_list, order: nil)
      expect(task_list).to be_invalid
    end

    it "validates value of order" do
      task_list = build(:task_list, order: 3)
      expect(task_list).to be_valid

      task_list = build(:task_list, order: 3.33)
      expect(task_list).to be_invalid

      task_list = build(:task_list, order: '3.33')
      expect(task_list).to be_invalid
    end
  end
end
