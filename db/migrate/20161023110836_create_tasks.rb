class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.integer :budget_id
      t.text :description
      t.date :due_by
      t.boolean :completed, :default => false

      t.timestamps
    end
  end
end
