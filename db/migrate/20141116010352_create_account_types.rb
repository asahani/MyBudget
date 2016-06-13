class CreateAccountTypes < ActiveRecord::Migration
  def change
    create_table :account_types do |t|
      t.string :name
      t.boolean :budget_account, :default => false

      t.timestamps
    end
  end
end
