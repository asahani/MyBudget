class AddIndexes < ActiveRecord::Migration[4.2]
  def self.up
      add_index :account_transactions, :account_id
      add_index :account_transactions, :budget_id
      add_index :account_transactions, :payee_id
      add_index :account_transactions, :category_id

      add_index :accounts, :account_type_id
      add_index :accounts, :is_active

      add_index :budget_accounts, :budget_id
      add_index :budget_accounts, :account_id
      add_index :budget_accounts, [:account_id,:budget_id]

      add_index :budget_incomes, :income_id
      add_index :budget_incomes, :account_id
      add_index :budget_incomes, :budget_id
      add_index :budget_incomes, :budget_transaction_id

      add_index :budget_items, :budget_id
      add_index :budget_items, :category_id

      add_index :budget_transactions, :account_id
      add_index :budget_transactions, :budget_item_id
      add_index :budget_transactions, :budget_id
      add_index :budget_transactions, :payee_id
      add_index :budget_transactions, :category_id
      add_index :budget_transactions, :budgeted

      add_index :budgets, :year
      add_index :budgets, :month

      add_index :categories, :master_category_id
      add_index :categories, :account_id
      add_index :categories, :payee_id
      add_index :categories, :miscellaneous
      add_index :categories, :budgeted

      add_index :goals, :account_id

      add_index :income_splits, :budget_id
      add_index :income_splits, :income_id

      add_index :incomes, :account_id

      add_index :payee_descriptions, :payee_id

      add_index :payees, :account_id
      add_index :payees, :category_id

      add_index :tasks, :budget_id

  end
end
