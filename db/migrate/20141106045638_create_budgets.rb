class CreateBudgets < ActiveRecord::Migration
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
