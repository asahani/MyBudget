# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Mandatory Master Categories
MasterCategory.create!(name: 'Income', display: false) #Should always be first
MasterCategory.create!(name: 'Account Transfer', display: false) #Should always be second
MasterCategory.create!(name: 'Savings', display: false) #Should always be third
MasterCategory.create!(name: 'Miscellaneous', display: false)#Should always be fourth
MasterCategory.create!(name: 'Cash', display: false)#Should always be fifth
MasterCategory.create!(name: 'Lending', display: false)#Should always be sixth
MasterCategory.create!(name: 'Investment', display: false)#Should always be seventh
#---------------------------

#Mandatory Categories
Category.create!(name: 'Income', active: false, budget_amount: 0.0,master_category_id: 1,mandatory: false,miscellaneous: false,savings: false) #Should always be first
Category.create!(name: 'Account Transfer', active: false, budget_amount: 0.0,master_category_id: 2,mandatory: false,miscellaneous: false,savings: false) #Should always be second
Category.create!(name: 'Savings', active: false, budget_amount: 0.0,master_category_id: 3,mandatory: true,miscellaneous: false,savings: true) #Should always be third
Category.create!(name: 'Miscellaneous', active: false, budget_amount: 1000.00,master_category_id: 4,mandatory: true,miscellaneous: true,savings: false) #Should always be fourth
Category.create!(name: 'Cash', active: false, budget_amount: 0.0,master_category_id: 5,mandatory: false,miscellaneous: false,savings: false) #Should always be fifth
Category.create!(name: 'Lending', active: false, budget_amount: 0.0,master_category_id: 6,mandatory: false,miscellaneous: false,savings: false) #Should always be sixth
Category.create!(name: 'Investment', active: false, budget_amount: 0.0,master_category_id: 7,mandatory: false,miscellaneous: false,savings: false) #Should always be seventh
#---------------------------

# Mandatory Payees
Payee.create!(name: 'Income', description: 'Income', category_id: 1,is_system: true) #Should always be first
Payee.create!(name: 'Savings', description: 'Savings', category_id: 3,is_system: true) #Should always be Second
Payee.create!(name: 'Cash', description: 'Cash', category_id: 5,is_system: true) #Should always be Third
Payee.create!(name: 'Miscellaneous', description: 'Miscellaneous', category_id: 4,is_system: true) #Should always be Fourth
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

MasterCategory.create!(name: 'God Charity', display: true)
MasterCategory.create!(name: 'India', display: true)
MasterCategory.create!(name: 'Household', display: true)
MasterCategory.create!(name: 'Personal', display: true)
MasterCategory.create!(name: 'Loans', display: true)
MasterCategory.create!(name: 'Insurance', display: true)
MasterCategory.create!(name: 'Utilities', display: true)
MasterCategory.create!(name: 'Transportation', display: true)
MasterCategory.create!(name: 'Aarav', display: true)
MasterCategory.create!(name: 'Leisure', display: true)
MasterCategory.create!(name: 'Medical', display: true)

Category.create!(name: 'God', active: true, budget_amount: 70.00,master_category_id: 7,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Money To India', active: true, budget_amount: 1000.00,master_category_id: 8,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Mortgage', active: true, budget_amount: 3615.00,master_category_id: 11,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Personal', active: true, budget_amount: 500.00,master_category_id: 10,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Groceries', active: true, budget_amount: 500.00,master_category_id: 9,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Car Loan', active: true, budget_amount: 555.00,master_category_id: 11,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Car Insurance', active: true, budget_amount: 82.00,master_category_id: 12,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Medical Insurance', active: true, budget_amount: 281.00,master_category_id: 12,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Home Insurance', active: true, budget_amount: 62.00,master_category_id: 12,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Electricity', active: true, budget_amount: 200.00,master_category_id: 13,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Gas', active: true, budget_amount: 50.00,master_category_id: 13,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Water', active: true, budget_amount: 50.00,master_category_id: 13,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Fuel', active: true, budget_amount: 100.00,master_category_id: 14,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Tesltra Home', active: true, budget_amount: 202.00,master_category_id: 13,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Mobiles', active: true, budget_amount: 50.00,master_category_id: 13,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Childcare', active: true, budget_amount: 320.00,master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'ASG', active: true, budget_amount: 165.00,master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Cleaning', active: true, budget_amount: 100.00,master_category_id: 9,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Kumon', active: true, budget_amount: 120.00,master_category_id: 15,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Interest Free', active: true, budget_amount: 100.00,master_category_id: 11,mandatory: true,miscellaneous: false,savings: false, budgeted: true)
Category.create!(name: 'Myki', active: true, budget_amount: 400.00,master_category_id: 14,mandatory: true,miscellaneous: false,savings: false, budgeted: true)

Category.create!(name: 'Apps', active: true, budget_amount: 0.00,master_category_id: 16,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Eating Out', active: true, budget_amount: 0.00,master_category_id: 16,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Doctor', active: true, budget_amount: 0.00,master_category_id: 17,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Medicines', active: true, budget_amount: 0.00,master_category_id: 17,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Clothes', active: true, budget_amount: 0.00,master_category_id: 10,mandatory: false,miscellaneous: true,savings: false, budgeted: false)
Category.create!(name: 'Shoes', active: true, budget_amount: 0.00,master_category_id: 10,mandatory: false,miscellaneous: true,savings: false, budgeted: false)

Account.create!(name: 'Citi Shruti', initial_balance: 0.00, balance: 0.00, account_type_id: 1,budget_account: true)
Account.create!(name: 'Citi Aman', initial_balance: 0.00, balance: 0.00, account_type_id: 1,budget_account: true)
Account.create!(name: 'Citi Savings', initial_balance: 12000.00, balance: 12000.00, account_type_id: 2,budget_account: true)
Account.create!(name: 'Citi Platinum', initial_balance: 0.00, balance: 0.00, account_type_id: 3,budget_account: true,is_debit_negetive: true,import_txn_date_col: 0,import_txn_amount_col: 1, import_txn_description_col: 5,import_txn_balance_col: nil,import_txn_date_format: '%e-%b-%y')
Account.create!(name: 'Amex Aman', initial_balance: 0.00, balance: 0.00, account_type_id: 3,budget_account: true,is_debit_negetive: false,import_txn_date_col: 0,import_txn_amount_col: 1, import_txn_description_col: 2,import_txn_date_format: '%d/%m/%Y')
Account.create!(name: 'NAB Offset', initial_balance: 300000.00, balance: 300000.00,balance: 300000.00, account_type_id: 4,budget_account: false)
Account.create!(name: 'Comsec', initial_balance: 45000.00,balance: 45000.00, account_type_id: 6,budget_account: false)
Account.create!(name: 'GO Mastercard', initial_balance: -3500.00, balance: -3500.00, account_type_id: 7,budget_account: false)
Account.create!(name: 'Sunny Bakshi', initial_balance: 0.00, balance: 0.00, account_type_id: 5,budget_account: false)

Payee.create!(name: 'Telstra', description: 'Telstra', category_id: 19)
Payee.create!(name: 'MYKI', description: 'MYKI.                    DOCKLANDS', category_id: 26)
Payee.create!(name: 'Itunes Apps', description: 'ITUNES MUSIC STSYDNEY', category_id: 27)
Payee.create!(name: 'Safeway', description: 'SAFEWAY', category_id: 10)

PayeeDescription.create!(description: 'SAFEWAY 3128 DONCASTER VIDONCASTER', payee: Payee.find_by_name("Safeway"))

Income.create!(description: 'Shruti Salary',amount: 4000.00, weekly: false, fortnightly: false, monthly: true, account_id: 1)
Income.create!(description: 'Aman Salary',amount: 1018.50, weekly: true, fortnightly: false, monthly: false, account_id: 2)
