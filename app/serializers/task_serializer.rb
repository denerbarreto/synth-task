class TaskSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :date_start, :date_end, :status, :priority

  belongs_to :user
  belongs_to :task_list
end
