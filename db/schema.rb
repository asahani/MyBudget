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

ActiveRecord::Schema.define(version: 20161023110836) do

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

  create_table "budget_incomes", force: true do |t|
    t.string   "description"
    t.decimal  "amount",                precision: 10, scale: 2, default: 0.0
    t.integer  "income_id"
    t.integer  "budget_id"
    t.integer  "account_id"
    t.integer  "budget_transaction_id"
    t.boolean  "credited"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "budget_transactions", force: true do |t|
    t.integer  "account_id"
    t.integer  "budget_item_id"
    t.integer  "payee_id"
    t.integer  "budget_id"
    t.integer  "category_id"
    t.decimal  "credit",           precision: 10, scale: 2, default: 0.0
    t.decimal  "debit",            precision: 10, scale: 2, default: 0.0
    t.date     "transaction_date"
    t.text     "comments"
    t.string   "raw_data"
    t.boolean  "manual",                                    default: true
    t.boolean  "scheduled",                                 default: false
    t.boolean  "budgeted",                                  default: false
    t.boolean  "miscellaneous",                             default: true
    t.boolean  "savings",                                   default: false
    t.boolean  "reconciled",                                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "budgets", force: true do |t|
    t.integer  "year"
    t.integer  "month",      limit: 2
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

  create_table "master_categories", force: true do |t|
    t.string   "name"
    t.boolean  "display",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payee_descriptions", force: true do |t|
    t.string   "description"
    t.integer  "payee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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

end
