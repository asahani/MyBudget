# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Mandatory Master Categories
MasterCategory.create!(name: 'Income', display: false)            #1 Should always be first
MasterCategory.create!(name: 'Account Transfer', display: false)  #2 Should always be second
MasterCategory.create!(name: 'Savings', display: false)           #3 Should always be third
MasterCategory.create!(name: 'Miscellaneous', display: false)     #4 Should always be fourth
MasterCategory.create!(name: 'Cash', display: false)              #5 Should always be fifth
MasterCategory.create!(name: 'Lending', display: false)           #6 Should always be sixth
MasterCategory.create!(name: 'Investment', display: false)        #7 Should always be seventh
MasterCategory.create!(name: 'Unknown', display: false)           #8 Should always be eighth
#---------------------------
MasterCategory.create!(name: 'God Charity', display: true)        #9 Should always be eighth
MasterCategory.create!(name: 'India', display: true)              #10 Should always be eighth
MasterCategory.create!(name: 'Loans', display: true)              #11 Should always be eighth
MasterCategory.create!(name: 'Household', display: true)          #12 Should always be eighth
MasterCategory.create!(name: 'Personal', display: true)           #13 Should always be eighth
MasterCategory.create!(name: 'Insurance', display: true)          #14 Should always be eighth
MasterCategory.create!(name: 'Utilities', display: true)          #15 Should always be eighth
MasterCategory.create!(name: 'Transportation', display: true)     #16 Should always be eighth
MasterCategory.create!(name: 'Aarav', display: true)              #17 Should always be eighth
MasterCategory.create!(name: 'Leisure', display: true)            #18 Should always be eighth

MasterCategory.create!(name: 'Medical', display: true)           #19 Should always be eighth
MasterCategory.create!(name: 'Fees', display: true)              #20 Should always be eighth
MasterCategory.create!(name: 'Services', display: true)          #21 Should always be eighth
MasterCategory.create!(name: 'Travel', display: true)            #22 Should always be eighth

#Mandatory Categories
Category.create!(name: 'Income', active: false, budget_amount: 0.0,           master_category_id: 1,mandatory: false,miscellaneous: false,savings: false) #Should always be first
Category.create!(name: 'Account Transfer', active: false, budget_amount: 0.0, master_category_id: 2,mandatory: false,miscellaneous: false,savings: false) #Should always be second
Category.create!(name: 'Savings', active: false, budget_amount: 0.0,          master_category_id: 3,mandatory: true,miscellaneous: false,savings: true) #Should always be third
Category.create!(name: 'Miscellaneous', active: false, budget_amount: 1000.00,master_category_id: 4,mandatory: true,miscellaneous: true,savings: false) #Should always be fourth
Category.create!(name: 'Cash', active: false, budget_amount: 0.0,             master_category_id: 5,mandatory: false,miscellaneous: false,savings: false) #Should always be fifth
Category.create!(name: 'Lending', active: false, budget_amount: 0.0,          master_category_id: 6,mandatory: false,miscellaneous: false,savings: false) #Should always be sixth
Category.create!(name: 'Investment', active: false, budget_amount: 0.0,       master_category_id: 7,mandatory: false,miscellaneous: false,savings: false) #Should always be seventh
Category.create!(name: 'Unknown', active: false, budget_amount: 0.0,          master_category_id: 8,mandatory: false,miscellaneous: false,savings: false) #Should always be eighth
#---------------------------

Category.create!(name: 'God', active: true, budget_amount: 50.00,             master_category_id: 9,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Money To India', active: true, budget_amount: 1500.00,master_category_id: 10,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Mortgage', active: true, budget_amount: 3615.00,      master_category_id: 11,mandatory: true,miscellaneous: false,savings: false, budgeted: true,scheduled: true,scheduled_day: 28,direct_debit: true)
Category.create!(name: 'Car Loan', active: true, budget_amount: 1051.00,      master_category_id: 11,mandatory: true,miscellaneous: false,savings: false, budgeted: true,scheduled: true,scheduled_day: 7)
Category.create!(name: 'Interest Free', active: true, budget_amount: 0.00,    master_category_id: 11,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Groceries', active: true, budget_amount: 600.00,      master_category_id: 12,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Cleaning', active: true, budget_amount: 400.00,       master_category_id: 12,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Personal', active: true, budget_amount: 500.00,       master_category_id: 13,mandatory: true,miscellaneous: false,savings: false, budgeted: true)

Category.create!(name: 'Car Insurance', active: true, budget_amount: 114.28,  master_category_id: 14,mandatory: true,miscellaneous: false,savings: false, budgeted: true,scheduled: true,scheduled_day: 17,direct_debit: true)
Category.create!(name: 'Medical Insurance', active: true, budget_amount: 281.00,master_category_id: 14,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Home Insurance', active: true, budget_amount: 84.29,  master_category_id: 14,mandatory: true,miscellaneous: false,savings: false, budgeted: true,scheduled: true,scheduled_day: 28,direct_debit: true)
Category.create!(name: 'Electricity', active: true, budget_amount: 200.00,    master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true,scheduled: true,scheduled_day: 21,direct_debit: true)
Category.create!(name: 'Gas', active: true, budget_amount: 50.00,             master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true,direct_debit: true)
Category.create!(name: 'Water', active: true, budget_amount: 150.00,          master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true,direct_debit: true)
Category.create!(name: 'Mobiles', active: true, budget_amount: 100.00,        master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Internet', active: true, budget_amount: 82.00,        master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Foxtel', active: true, budget_amount: 120.00,         master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true)

Category.create!(name: 'Fuel', active: true, budget_amount: 150.00,           master_category_id: 16,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Parking', active: true, budget_amount: 200.00,        master_category_id: 16,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Myki', active: true, budget_amount: 200.00,           master_category_id: 16,mandatory: true,miscellaneous: false,savings: false, budgeted: true)

Category.create!(name: 'Childcare', active: true, budget_amount: 320.00,      master_category_id: 17,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'ASG', active: true, budget_amount: 199.07,            master_category_id: 17,mandatory: true,miscellaneous: false,savings: false, budgeted: true,scheduled: true,scheduled_day: 1,direct_debit: true)
Category.create!(name: 'Kumon', active: true, budget_amount: 130.00,          master_category_id: 17,mandatory: true,miscellaneous: false,savings: false, budgeted: true)

Category.create!(name: 'Eating Out', active: true, budget_amount: 500.00,     master_category_id: 18,mandatory: true,miscellaneous: false,savings: false, budgeted: true)

Category.create!(name: 'Software', active: true, budget_amount: 0.00,         master_category_id: 21,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Subscriptions', active: true, budget_amount: 0.00,    master_category_id: 21,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Doctor', active: true, budget_amount: 0.00,           master_category_id: 19,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Medicines', active: true, budget_amount: 0.00,        master_category_id: 19,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Clothes', active: true, budget_amount: 0.00,          master_category_id: 13,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Shoes', active: true, budget_amount: 0.00,            master_category_id: 13,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Toys', active: true, budget_amount: 0.00,             master_category_id: 13,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Council', active: true, budget_amount: 0.00,          master_category_id: 20,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Vacation', active: true, budget_amount: 0.00,         master_category_id: 22,mandatory: false,miscellaneous: true,savings: false, budgeted: false)

# Mandatory Payees
Payee.create!(name: 'Income', description: 'Income', category_id: 1,is_system: true) #Should always be first
Payee.create!(name: 'Savings', description: 'Savings', category_id: 3,is_system: true) #Should always be Second
Payee.create!(name: 'Cash', description: 'Cash', category_id: 5,is_system: true) #Should always be Third
Payee.create!(name: 'Miscellaneous', description: 'Miscellaneous', category_id: 4,is_system: true) #Should always be Fourth
Payee.create!(name: 'Unknown', description: 'Unknown', category_id: 8,is_system: true) #Should always be Fifth
#---------------------------

# Mandatory Account Types
AccountType.create!(name: 'Transaction') #Should always be first
AccountType.create!(name: 'Savings') #Should always be first
AccountType.create!(name: 'Credit') #Should always be first
AccountType.create!(name: 'Offset') #Should always be first
AccountType.create!(name: 'Loan') #Should always be first
AccountType.create!(name: 'Brokerage') #Should always be first
AccountType.create!(name: 'Interest Free') #Should always be first
AccountType.create!(name: 'Mortgage') #Should always be first
AccountType.create!(name: 'Superannuation') #Should always be first
#---------------------------

Account.create!(name: 'CBA Shruti', initial_balance: 0.00, balance: 0.00, account_type_id: 1,budget_account: true)
Account.create!(name: 'CBA Aman', initial_balance: 0.00, balance: 0.00, account_type_id: 1,budget_account: true)
Account.create!(name: 'CBA Joint', initial_balance: 0.00, balance: 0.00, account_type_id: 1,budget_account: true)
Account.create!(name: 'CBA Savings', initial_balance: 0.00, balance: 0.00, account_type_id: 2,budget_account: true)
Account.create!(name: 'Combank Mastercard', initial_balance: 0.00, balance: 0.00, account_type_id: 3,budget_account: true,is_debit_negetive: true,import_txn_date_col: 0,import_txn_amount_col: 1, import_txn_description_col: 2,import_txn_balance_col: nil,import_txn_date_format: '%d/%m/%y')
Account.create!(name: 'Amex Aman', initial_balance: 0.00, balance: 0.00, account_type_id: 3,budget_account: true,is_debit_negetive: false,import_txn_date_col: 0,import_txn_amount_col: 1, import_txn_description_col: 2,import_txn_date_format: '%d/%m/%Y')
Account.create!(name: 'Combank Offset', initial_balance: 340000.00, balance: 340000.00, account_type_id: 4,budget_account: false)
Account.create!(name: 'Comsec', initial_balance: 0.00,balance: 0.00, account_type_id: 6,budget_account: false)
Account.create!(name: 'Sunny Bakshi', initial_balance: 0.00, balance: 0.00, account_type_id: 5,budget_account: false)
Account.create!(name: 'Keshav Loomba', initial_balance: 0.00, balance: 0.00, account_type_id: 5,budget_account: false)

Payee.create!(name: 'Telstra', description: 'Telstra', category_id: 23)
Payee.create!(name: 'MYKI', description: 'MYKI.                    DOCKLANDS', category_id: 25)
Payee.create!(name: 'Itunes Apps', description: 'ITUNES MUSIC STSYDNEY', category_id: 30)
Payee.create!(name: 'Safeway', description: 'SAFEWAY', category_id: 6)

PayeeDescription.create!(description: 'SAFEWAY 3128 DONCASTER VIDONCASTER', payee: Payee.find_by_name("Safeway"))

Income.create!(description: 'Shruti Medibank',amount: 3477.24, weekly: false, fortnightly: true, monthly: false, account_id: 1)
Income.create!(description: 'Aman Sensis',amount: 4344.15, weekly: false, fortnightly: true, monthly: false, account_id: 2)

user1 = User.create(username: 'admin',email: 'aman.sahani@gmail.com',password: 'password123',password_confirmation: 'password123')
