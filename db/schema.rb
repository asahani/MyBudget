# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170723064814) do

  create_table "account_transactions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "account_id"
    t.integer "payee_id"
    t.integer "budget_id"
    t.integer "category_id"
    t.decimal "amount", precision: 10
    t.date "transaction_date"
    t.string "comments"
    t.boolean "reconciled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "house_id"
    t.integer "share_id"
    t.index ["account_id"], name: "index_account_transactions_on_account_id"
    t.index ["budget_id"], name: "index_account_transactions_on_budget_id"
    t.index ["category_id"], name: "index_account_transactions_on_category_id"
    t.index ["payee_id"], name: "index_account_transactions_on_payee_id"
  end

  create_table "account_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.decimal "initial_balance", precision: 10, scale: 2, default: "0.0"
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.integer "account_type_id", default: 1
    t.boolean "budget_account", default: true
    t.integer "bsb_number"
    t.integer "card_number"
    t.integer "username"
    t.string "hint"
    t.boolean "is_active", default: true
    t.boolean "is_debit_negetive", default: true
    t.integer "import_txn_date_col"
    t.integer "import_txn_amount_col"
    t.integer "import_txn_description_col"
    t.integer "import_txn_balance_col"
    t.string "import_txn_date_format"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_type_id"], name: "index_accounts_on_account_type_id"
    t.index ["is_active"], name: "index_accounts_on_is_active"
  end

  create_table "budget_accounts", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "account_id"
    t.integer "budget_id"
    t.decimal "opening_balance", precision: 10, scale: 2, default: "0.0"
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.decimal "statement_balance", precision: 10, scale: 2, default: "0.0"
    t.boolean "paid", default: false
    t.boolean "reconciled", default: false
    t.boolean "documented", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id", "budget_id"], name: "index_budget_accounts_on_account_id_and_budget_id"
    t.index ["account_id"], name: "index_budget_accounts_on_account_id"
    t.index ["budget_id"], name: "index_budget_accounts_on_budget_id"
  end

  create_table "budget_incomes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "description"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.integer "income_id"
    t.integer "budget_id"
    t.integer "account_id"
    t.integer "budget_transaction_id"
    t.boolean "credited"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "dividend_income_share_id"
    t.index ["account_id"], name: "index_budget_incomes_on_account_id"
    t.index ["budget_id"], name: "index_budget_incomes_on_budget_id"
    t.index ["budget_transaction_id"], name: "index_budget_incomes_on_budget_transaction_id"
    t.index ["income_id"], name: "index_budget_incomes_on_income_id"
  end

  create_table "budget_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "budget_id"
    t.integer "category_id"
    t.decimal "budgeted_amount", precision: 10, scale: 2
    t.date "payment_date"
    t.decimal "expenses", precision: 10, scale: 2, default: "0.0"
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.text "comment"
    t.boolean "complete", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["budget_id"], name: "index_budget_items_on_budget_id"
    t.index ["category_id"], name: "index_budget_items_on_category_id"
  end

  create_table "budget_transactions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "account_id"
    t.integer "budget_item_id"
    t.integer "payee_id"
    t.integer "budget_id"
    t.integer "category_id"
    t.decimal "credit", precision: 10, scale: 2, default: "0.0"
    t.decimal "debit", precision: 10, scale: 2, default: "0.0"
    t.date "transaction_date"
    t.text "comments"
    t.string "raw_data"
    t.boolean "manual", default: true
    t.boolean "scheduled", default: false
    t.boolean "budgeted", default: false
    t.boolean "miscellaneous", default: true
    t.boolean "savings", default: false
    t.boolean "reconciled", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "mortgage_interest", precision: 10, scale: 2, default: "0.0"
    t.decimal "mortgage_principal", precision: 10, scale: 2, default: "0.0"
    t.index ["account_id"], name: "index_budget_transactions_on_account_id"
    t.index ["budget_id"], name: "index_budget_transactions_on_budget_id"
    t.index ["budget_item_id"], name: "index_budget_transactions_on_budget_item_id"
    t.index ["budgeted"], name: "index_budget_transactions_on_budgeted"
    t.index ["category_id"], name: "index_budget_transactions_on_category_id"
    t.index ["payee_id"], name: "index_budget_transactions_on_payee_id"
  end

  create_table "budgets", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "year"
    t.integer "month", limit: 2
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "is_closed", default: false
    t.string "name"
    t.index ["month"], name: "index_budgets_on_month"
    t.index ["year"], name: "index_budgets_on_year"
  end

  create_table "categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.boolean "active", default: true
    t.decimal "budget_amount", precision: 10, scale: 2
    t.integer "master_category_id"
    t.boolean "mandatory", default: false
    t.boolean "budgeted", default: false
    t.boolean "miscellaneous", default: false
    t.boolean "savings", default: false
    t.boolean "direct_debit", default: false
    t.boolean "scheduled", default: false
    t.integer "scheduled_day"
    t.boolean "has_template_transaction", default: false
    t.integer "account_id"
    t.integer "payee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "icon"
    t.index ["account_id"], name: "index_categories_on_account_id"
    t.index ["budgeted"], name: "index_categories_on_budgeted"
    t.index ["master_category_id"], name: "index_categories_on_master_category_id"
    t.index ["miscellaneous"], name: "index_categories_on_miscellaneous"
    t.index ["payee_id"], name: "index_categories_on_payee_id"
  end

  create_table "goals", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "icon"
    t.decimal "target_amount", precision: 10, default: "0"
    t.decimal "saved_amount", precision: 10, default: "0"
    t.date "target_date"
    t.integer "account_id"
    t.integer "percentage_towards_goal"
    t.decimal "current_balance_towards_goal", precision: 10, default: "0"
    t.boolean "is_active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_goals_on_account_id"
  end

  create_table "houses", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "address"
    t.integer "mortgage_account_id"
    t.integer "offset_account_id"
    t.date "purchase_date"
    t.float "price_paid", limit: 24
    t.float "original_balance", limit: 24
    t.float "current_value", limit: 24
    t.float "interest_rate", limit: 24
    t.float "term_length", limit: 24
    t.date "term_start_date"
    t.float "monthly_payment", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imported_transactions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "raw_data"
    t.decimal "credit", precision: 10, scale: 2
    t.decimal "debit", precision: 10, scale: 2
    t.date "txn_date"
    t.string "description"
    t.decimal "balance", precision: 10, scale: 2
    t.integer "account_id"
    t.integer "payee_id"
    t.integer "category_id"
    t.integer "budget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "tags"
  end

  create_table "income_splits", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "budget_id"
    t.integer "income_id"
    t.date "income_split_date"
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "total_received", precision: 10, scale: 2
    t.boolean "is_last_for_month", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["budget_id"], name: "index_income_splits_on_budget_id"
    t.index ["income_id"], name: "index_income_splits_on_income_id"
  end

  create_table "incomes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "description"
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.boolean "weekly", default: false
    t.boolean "fortnightly", default: false
    t.boolean "monthly", default: true
    t.integer "account_id"
    t.boolean "is_active", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_incomes_on_account_id"
  end

  create_table "master_categories", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.boolean "display", default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "icon"
  end

  create_table "net_worths", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "account_id"
    t.integer "share_id"
    t.integer "house_id"
    t.integer "budget_id"
    t.date "capture_date"
    t.decimal "value", precision: 10, default: "0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_net_worths_on_account_id"
    t.index ["budget_id"], name: "index_net_worths_on_budget_id"
    t.index ["house_id"], name: "index_net_worths_on_house_id"
    t.index ["share_id"], name: "index_net_worths_on_share_id"
  end

  create_table "payee_descriptions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "description"
    t.integer "payee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["payee_id"], name: "index_payee_descriptions_on_payee_id"
  end

  create_table "payees", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "description"
    t.integer "category_id"
    t.boolean "is_system", default: false
    t.boolean "is_account", default: false
    t.integer "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_payees_on_account_id"
    t.index ["category_id"], name: "index_payees_on_category_id"
  end

  create_table "shares", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name"
    t.string "code"
    t.string "share_type"
    t.decimal "units", precision: 10
    t.decimal "purchase_price", precision: 10, scale: 3
    t.date "purchase_date"
    t.decimal "last_price", precision: 10, scale: 3
    t.decimal "sell_price", precision: 10, scale: 3
    t.date "sell_date"
    t.integer "brokerage_account_id"
    t.boolean "no_cash_transaction", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tasks", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer "budget_id"
    t.string "title"
    t.text "description"
    t.integer "priority"
    t.date "due_by"
    t.boolean "completed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["budget_id"], name: "index_tasks_on_budget_id"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
