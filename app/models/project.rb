class Project < ApplicationRecord
  belongs_to :user
  has_many :task_lists

  validates :name, presence: true, length: {minimum: 3, maximum: 50}
end
