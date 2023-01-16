class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.date :date_start
      t.date :date_end
      t.string :status
      t.integer :priority
      t.references :user, null: false, foreign_key: true
      t.references :task_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
