# encoding: UTF-8
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

  create_table "account_transactions", force: true do |t|
    t.integer  "account_id"
    t.integer  "payee_id"
    t.integer  "budget_id"
    t.integer  "category_id"
    t.decimal  "amount",           precision: 10, scale: 0
    t.date     "transaction_date"
    t.string   "comments"
    t.boolean  "reconciled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "house_id"
    t.integer  "share_id"
  end

  add_index "account_transactions", ["account_id"], name: "index_account_transactions_on_account_id", using: :btree
  add_index "account_transactions", ["budget_id"], name: "index_account_transactions_on_budget_id", using: :btree
  add_index "account_transactions", ["category_id"], name: "index_account_transactions_on_category_id", using: :btree
  add_index "account_transactions", ["payee_id"], name: "index_account_transactions_on_payee_id", using: :btree

  create_table "account_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.decimal  "initial_balance",            precision: 10, scale: 2, default: 0.0
    t.decimal  "balance",                    precision: 10, scale: 2, default: 0.0
    t.integer  "account_type_id",                                     default: 1
    t.boolean  "budget_account",                                      default: true
    t.integer  "bsb_number"
    t.integer  "card_number"
    t.integer  "username"
    t.string   "hint"
    t.boolean  "is_active",                                           default: true
    t.boolean  "is_debit_negetive",                                   default: true
    t.integer  "import_txn_date_col"
    t.integer  "import_txn_amount_col"
    t.integer  "import_txn_description_col"
    t.integer  "import_txn_balance_col"
    t.string   "import_txn_date_format"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["account_type_id"], name: "index_accounts_on_account_type_id", using: :btree
  add_index "accounts", ["is_active"], name: "index_accounts_on_is_active", using: :btree

  create_table "budget_accounts", force: true do |t|
    t.integer  "account_id"
    t.integer  "budget_id"
    t.decimal  "opening_balance",   precision: 10, scale: 2, default: 0.0
    t.decimal  "balance",           precision: 10, scale: 2, default: 0.0
    t.decimal  "statement_balance", precision: 10, scale: 2, default: 0.0
    t.boolean  "paid",                                       default: false
    t.boolean  "reconciled",                                 default: false
    t.boolean  "documented",                                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "budget_accounts", ["account_id", "budget_id"], name: "index_budget_accounts_on_account_id_and_budget_id", using: :btree
  add_index "budget_accounts", ["account_id"], name: "index_budget_accounts_on_account_id", using: :btree
  add_index "budget_accounts", ["budget_id"], name: "index_budget_accounts_on_budget_id", using: :btree

  create_table "budget_incomes", force: true do |t|
    t.string   "description"
    t.decimal  "amount",                   precision: 10, scale: 2, default: 0.0
    t.integer  "income_id"
    t.integer  "budget_id"
    t.integer  "account_id"
    t.integer  "budget_transaction_id"
    t.boolean  "credited"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dividend_income_share_id"
  end

  add_index "budget_incomes", ["account_id"], name: "index_budget_incomes_on_account_id", using: :btree
  add_index "budget_incomes", ["budget_id"], name: "index_budget_incomes_on_budget_id", using: :btree
  add_index "budget_incomes", ["budget_transaction_id"], name: "index_budget_incomes_on_budget_transaction_id", using: :btree
  add_index "budget_incomes", ["income_id"], name: "index_budget_incomes_on_income_id", using: :btree

  create_table "budget_items", force: true do |t|
    t.integer  "budget_id"
    t.integer  "category_id"
    t.decimal  "budgeted_amount", precision: 10, scale: 2
    t.date     "payment_date"
    t.decimal  "expenses",        precision: 10, scale: 2, default: 0.0
    t.decimal  "balance",         precision: 10, scale: 2, default: 0.0
    t.text     "comment"
    t.boolean  "complete",                                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "budget_items", ["budget_id"], name: "index_budget_items_on_budget_id", using: :btree
  add_index "budget_items", ["category_id"], name: "index_budget_items_on_category_id", using: :btree

  create_table "budget_transactions", force: true do |t|
    t.integer  "account_id"
    t.integer  "budget_item_id"
    t.integer  "payee_id"
    t.integer  "budget_id"
    t.integer  "category_id"
    t.decimal  "credit",             precision: 10, scale: 2, default: 0.0
    t.decimal  "debit",              precision: 10, scale: 2, default: 0.0
    t.date     "transaction_date"
    t.text     "comments"
    t.string   "raw_data"
    t.boolean  "manual",                                      default: true
    t.boolean  "scheduled",                                   default: false
    t.boolean  "budgeted",                                    default: false
    t.boolean  "miscellaneous",                               default: true
    t.boolean  "savings",                                     default: false
    t.boolean  "reconciled",                                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "mortgage_interest",  precision: 10, scale: 2, default: 0.0
    t.decimal  "mortgage_principal", precision: 10, scale: 2, default: 0.0
  end

  add_index "budget_transactions", ["account_id"], name: "index_budget_transactions_on_account_id", using: :btree
  add_index "budget_transactions", ["budget_id"], name: "index_budget_transactions_on_budget_id", using: :btree
  add_index "budget_transactions", ["budget_item_id"], name: "index_budget_transactions_on_budget_item_id", using: :btree
  add_index "budget_transactions", ["budgeted"], name: "index_budget_transactions_on_budgeted", using: :btree
  add_index "budget_transactions", ["category_id"], name: "index_budget_transactions_on_category_id", using: :btree
  add_index "budget_transactions", ["payee_id"], name: "index_budget_transactions_on_payee_id", using: :btree

  create_table "budgets", force: true do |t|
    t.integer  "year"
    t.integer  "month",      limit: 2
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_closed",            default: false
    t.string   "name"
  end

  add_index "budgets", ["month"], name: "index_budgets_on_month", using: :btree
  add_index "budgets", ["year"], name: "index_budgets_on_year", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.boolean  "active",                                            default: true
    t.decimal  "budget_amount",            precision: 10, scale: 2
    t.integer  "master_category_id"
    t.boolean  "mandatory",                                         default: false
    t.boolean  "budgeted",                                          default: false
    t.boolean  "miscellaneous",                                     default: false
    t.boolean  "savings",                                           default: false
    t.boolean  "direct_debit",                                      default: false
    t.boolean  "scheduled",                                         default: false
    t.integer  "scheduled_day"
    t.boolean  "has_template_transaction",                          default: false
    t.integer  "account_id"
    t.integer  "payee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon"
  end

  add_index "categories", ["account_id"], name: "index_categories_on_account_id", using: :btree
  add_index "categories", ["budgeted"], name: "index_categories_on_budgeted", using: :btree
  add_index "categories", ["master_category_id"], name: "index_categories_on_master_category_id", using: :btree
  add_index "categories", ["miscellaneous"], name: "index_categories_on_miscellaneous", using: :btree
  add_index "categories", ["payee_id"], name: "index_categories_on_payee_id", using: :btree

  create_table "goals", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.decimal  "target_amount",                precision: 10, scale: 0, default: 0
    t.decimal  "saved_amount",                 precision: 10, scale: 0, default: 0
    t.date     "target_date"
    t.integer  "account_id"
    t.integer  "percentage_towards_goal"
    t.decimal  "current_balance_towards_goal", precision: 10, scale: 0, default: 0
    t.boolean  "is_active",                                             default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "goals", ["account_id"], name: "index_goals_on_account_id", using: :btree

  create_table "houses", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.integer  "mortgage_account_id"
    t.integer  "offset_account_id"
    t.date     "purchase_date"
    t.float    "price_paid",          limit: 24
    t.float    "original_balance",    limit: 24
    t.float    "current_value",       limit: 24
    t.float    "interest_rate",       limit: 24
    t.float    "term_length",         limit: 24
    t.date     "term_start_date"
    t.float    "monthly_payment",     limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "imported_transactions", force: true do |t|
    t.string   "raw_data"
    t.decimal  "credit",      precision: 10, scale: 2
    t.decimal  "debit",       precision: 10, scale: 2
    t.date     "txn_date"
    t.string   "description"
    t.decimal  "balance",     precision: 10, scale: 2
    t.integer  "account_id"
    t.integer  "payee_id"
    t.integer  "category_id"
    t.integer  "budget_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tags"
  end

  create_table "income_splits", force: true do |t|
    t.integer  "budget_id"
    t.integer  "income_id"
    t.date     "income_split_date"
    t.decimal  "amount",            precision: 10, scale: 2
    t.decimal  "total_received",    precision: 10, scale: 2
    t.boolean  "is_last_for_month",                          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "income_splits", ["budget_id"], name: "index_income_splits_on_budget_id", using: :btree
  add_index "income_splits", ["income_id"], name: "index_income_splits_on_income_id", using: :btree

  create_table "incomes", force: true do |t|
    t.string   "description"
    t.decimal  "amount",      precision: 10, scale: 2, default: 0.0
    t.boolean  "weekly",                               default: false
    t.boolean  "fortnightly",                          default: false
    t.boolean  "monthly",                              default: true
    t.integer  "account_id"
    t.boolean  "is_active",                            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "incomes", ["account_id"], name: "index_incomes_on_account_id", using: :btree

  create_table "master_categories", force: true do |t|
    t.string   "name"
    t.boolean  "display",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "icon"
  end

  create_table "net_worths", force: true do |t|
    t.integer  "account_id"
    t.integer  "share_id"
    t.integer  "house_id"
    t.integer  "budget_id"
    t.date     "capture_date"
    t.decimal  "value",        precision: 10, scale: 0, default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "net_worths", ["account_id"], name: "index_net_worths_on_account_id", using: :btree
  add_index "net_worths", ["budget_id"], name: "index_net_worths_on_budget_id", using: :btree
  add_index "net_worths", ["house_id"], name: "index_net_worths_on_house_id", using: :btree
  add_index "net_worths", ["share_id"], name: "index_net_worths_on_share_id", using: :btree

  create_table "payee_descriptions", force: true do |t|
    t.string   "description"
    t.integer  "payee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payee_descriptions", ["payee_id"], name: "index_payee_descriptions_on_payee_id", using: :btree

  create_table "payees", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "category_id"
    t.boolean  "is_system",   default: false
    t.boolean  "is_account",  default: false
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payees", ["account_id"], name: "index_payees_on_account_id", using: :btree
  add_index "payees", ["category_id"], name: "index_payees_on_category_id", using: :btree

  create_table "shares", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "share_type"
    t.decimal  "units",                precision: 10, scale: 0
    t.decimal  "purchase_price",       precision: 10, scale: 3
    t.date     "purchase_date"
    t.decimal  "last_price",           precision: 10, scale: 3
    t.decimal  "sell_price",           precision: 10, scale: 3
    t.date     "sell_date"
    t.integer  "brokerage_account_id"
    t.boolean  "no_cash_transaction",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["context"], name: "index_taggings_on_context", using: :btree
  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "tasks", force: true do |t|
    t.integer  "budget_id"
    t.string   "title"
    t.text     "description"
    t.integer  "priority"
    t.date     "due_by"
    t.boolean  "completed",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["budget_id"], name: "index_tasks_on_budget_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
