require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should allow_value("email@example.com").for(:email) }
    it { should_not allow_value("invalid_email").for(:email) }
    it { should have_secure_password }
    it { should validate_presence_of(:password) }
    it { should validate_confirmation_of(:password) }
    it { should validate_length_of(:password).is_at_least(8).is_at_most(20) }
    it { should validate_presence_of(:password_digest) }
  end

  describe "user model factory tests" do
    it "creates a valid user" do
      user = create(:user)
      expect(user).to be_valid
    end

    it "saves a user to the database" do
      user = build(:user)
      expect { user.save }.to change(User, :count).by(1)
    end

    it "validates presence of name" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
    end

    it "validates length of name" do
      user = build(:user, name: 'Ab')
      expect(user).to be_invalid
      
      user.name = 'A' * 51
      expect(user).to be_invalid
    end

    it "validates presence of email" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
    end

    it "validates uniqueness of email" do
      create(:user, email: 'user@example.com')
      user = build(:user, email: 'user@example.com')
      expect(user).to be_invalid
    end

    it "validates format of email" do
      user = build(:user, email: 'invalid_email')
      expect(user).to be_invalid
    end

    it "validates presence of password" do
      user = build(:user, password: nil)
      expect(user).to be_invalid
    end

    it "validates presence of password confirmation" do
      user = build(:user, password_confirmation: nil)
    end

    it "creates a user with a password that meets the minimum length requirement" do
      user = build(:user, password: "short")
      expect(user).to_not be_valid
    end

    it "creates a user with a password that meets the maximum length requirement" do
      user = build(:user, password: "thispasswordiswaytoolongandwillnotwork")
      expect(user).to_not be_valid
    end
  end
end
