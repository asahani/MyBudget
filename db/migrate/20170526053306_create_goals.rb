class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.string :name
      t.string :icon
      t.decimal :target_amount, :default => 0.00
      t.decimal :saved_amount, :default => 0.00
      t.date :target_date
      t.integer :account_id
      t.integer :percentage_towards_goal
      t.decimal :current_balance_towards_goal, :default => 0.00
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end
end
