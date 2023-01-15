class TaskList < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :name, presence: true, length: {minimum:3, maximum: 50}
  validates :order, presence: true, numericality: { only_integer: true }
end
