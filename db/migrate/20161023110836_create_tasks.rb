class CreateTasks < ActiveRecord::Migration[4.2]
  def change
    create_table :tasks do |t|
      t.integer :budget_id
      t.string :title
      t.text :description
      t.integer :priority
      t.date :due_by
      t.boolean :completed, :default => false

      t.timestamps
    end
  end
end
