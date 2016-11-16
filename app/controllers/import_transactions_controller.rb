class ImportTransactionsController < ApplicationController
  require 'csv'

  def open_file
    @budget = Budget.find(params[:budget_id])
  end

  def process_file
    @budget = Budget.find(params[:budget_id])
    session[:budget_id] = @budget.id

    ImportedTransaction.destroy_all
    account = Account.find(params[:account_id])
    import_balance_due = params[:import_balance_due]
    first_row = true

    CSV.foreach(params[:file].path, headers: false) do |row|
      imported_transaction, txn_date, txn_amount, txn_description, txn_balance,txn_date_format, payee, credit, debit, category_id, payee_id = nil

      payeeDescription = PayeeDescription.find_by_description(row[5])
      unless payeeDescription.nil?
        payee = payeeDescription.payee
      end


      unless account.import_txn_date_col.nil?
        txn_date = row[account.import_txn_date_col] unless account.import_txn_date_col.nil?
        txn_amount = row[account.import_txn_amount_col]
        txn_description = row[account.import_txn_description_col]
        txn_balance = row[account.import_txn_balance_col] unless account.import_txn_balance_col.nil?
        txn_date_format = account.import_txn_date_format

        unless payee.nil?
          payee_id = payee.id
          category_id= payee.category.id
        end

        if account.is_debit_negetive
          if txn_amount.to_f > 0
            credit = txn_amount.to_f
          else
            debit = txn_amount.to_f
          end
        else
          if txn_amount.to_f > 0
            debit = txn_amount.to_f * -1
          else
            credit = txn_amount.to_f.abs
          end
        end

        imported_transaction = ImportedTransaction.new(raw_data: row.to_s, credit: credit, debit: debit, txn_date: Date.strptime(txn_date.to_s,txn_date_format),
         description: txn_description, balance: txn_balance, account_id: account.id, payee_id: payee_id, category_id: category_id)

        budget_transaction = BudgetTransaction.find_by_raw_data(row.to_s)

        if first_row && imported_transaction.balance.nil? && !import_balance_due.nil?
          imported_transaction.balance = import_balance_due.to_f * -1
          first_row = false
        end

        if budget_transaction.nil? && !imported_transaction.nil?
          imported_transaction.save!

        end
      end
    end
  end

  def transfer
    @imported_transaction = ImportedTransaction.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def split
    @imported_transaction = ImportedTransaction.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def add_split
    imported_transaction = ImportedTransaction.find(params[:txn_id])
    credit = params[:credit]
    debit = params[:debit]
    category = params[:category_id]

    begin
      ImportedTransaction.transaction do

        if (category.nil?)
          raise 'Category cannot be blank. Please select or add a new payee.'
        end

        split_transaction = ImportedTransaction.new(raw_data: nil, credit: credit, debit: debit, txn_date: imported_transaction.txn_date,
         description: imported_transaction.description, balance: nil, account_id: imported_transaction.account.id, payee_id: imported_transaction.payee.id, category_id: category)

        split_transaction.save!

        unless(credit.nil?)
          imported_transaction.credit = imported_transaction.credit - credit.to_f
        end

        unless(debit.nil?)
          imported_transaction.debit = imported_transaction.debit - debit.to_f
        end

        imported_transaction.save!

        respond_to do |format|
          format.js
        end
      end
    rescue => e
      puts e.message
      @imported_transactions = ImportedTransaction.all
      render :process_file
    end

  end

  def tags
    @imported_transaction = ImportedTransaction.find(params[:id])

    respond_to do |format|
      format.js
    end
  end

  def add_tags
    @imported_transaction = ImportedTransaction.find(params[:txn_id])

    unless params[:tags].nil?
      @imported_transaction.tags = params[:tags]

      @imported_transaction.save!
    end

    respond_to do |format|
      format.js { render '/import_transactions/preview'}
    end

  end

  def update
    @imported_transaction = ImportedTransaction.find(params[:id])
    @imported_transaction.account_id = params[:imported_transaction][:account_id]
    @imported_transaction.payee_id = params[:imported_transaction][:payee_id]

    unless @imported_transaction.payee_id.nil?
      payee = Payee.find(@imported_transaction.payee_id)
      unless payee.nil?
        @imported_transaction.category_id = payee.category_id
      end
    end

    @imported_transaction.save!

    respond_to do |format|
      format.js { render '/import_transactions/preview'}
    end
  end

  def destroy
    imported_transaction = ImportedTransaction.find(params[:id])
    imported_transaction.destroy

    respond_to do |format|
      format.js { render '/import_transactions/preview'}
    end
  end

  def import
    unless session[:budget_id].nil?
      @budget = Budget.find(session[:budget_id])
    end

    begin
      ImportedTransaction.transaction do
        ImportedTransaction.all.each do |txn|
          misc = false
          is_budgeted = false
          budget_item_id = nil
          credit_val = 0.00
          debit_val = 0.00

          if (txn.payee.nil?)
            raise 'Payee cannot be blank. Please select or add a new payee.'
          end

          unless (txn.raw_data.nil?)
            existing_budget_transaction = BudgetTransaction.find_by_raw_data(txn.raw_data)
            unless (existing_budget_transaction.nil?)
              raise 'Duplicate transaction import detected. txn: ' + txn.raw_data.to_s
            end
          end

          unless (txn.credit.nil?)
            credit_val = txn.credit.abs
          end

          unless (txn.debit.nil?)
            debit_val = txn.debit.abs
          end
          budget = Budget.get_budget(txn.txn_date)
          category = Category.find(txn.category.id)
          budget_item = BudgetItem.find_by_budget_id_and_category_id(budget.id,category.id)

          if budget_item.nil?
            budget_item = BudgetItem.find_by_budget_id_and_category_id(budget.id,Category.find_by_miscellaneous_and_mandatory(true,true).id)
          end

          if category.miscellaneous
            misc = true
          elsif category.budgeted
            is_budgeted = true
          end

          unless budget_item.nil?
            budget_item_id = budget_item.id
          end

          budget_txn = BudgetTransaction.new(account_id: txn.account_id,budget_item_id: budget_item_id,payee_id: txn.payee_id,
            budget_id: budget.id,category_id: txn.category_id, credit: credit_val, debit: debit_val,
            transaction_date: txn.txn_date,comments: txn.description,raw_data:txn.raw_data ,
            manual: false, scheduled: false, budgeted: is_budgeted,miscellaneous: misc,savings: false,reconciled: false,tag_list: txn.tags)

          budget_txn.save!
          txn.budget_id = budget.id
          txn.save!
          # txn.destroy
        end
        # raise 'Test error'
        # redirect_to budgets_path
      end
    rescue => e
      flash.now[:error] = "Imported transactions could not be saved: #{e.message}"
      @imported_transactions = ImportedTransaction.all
      render :process_file
    end
  end

  def cancel
    ImportedTransaction.destroy_all

    redirect_to budgets_path
  end
end
