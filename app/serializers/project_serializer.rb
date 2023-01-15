class ProjectSerializer < ActiveModel::Serializer
  attributes :id, :name

  belongs_to :user
  has_many :task_lists
end
