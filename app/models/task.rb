class Task < ApplicationRecord
  belongs_to :user
  belongs_to :task_list

  validates :name, presence: true, length: {minimum: 3, maximum: 50}
  validates :status, presence: true, inclusion: { in: ["Em andamento", "Concluída", "Atrasada", "Cancelada"] }
  validates :description, :priority, presence: true
end
