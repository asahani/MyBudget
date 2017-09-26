class CreateBudgets < ActiveRecord::Migration[4.2]
  def change
    create_table :budgets do |t|
      t.integer :year
      t.integer :month, :limit => 2
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
