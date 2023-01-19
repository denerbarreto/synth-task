class TaskListSerializer < ActiveModel::Serializer
  attributes :id, :name, :order

  belongs_to :user
  belongs_to :project
  has_many :tasks
end
