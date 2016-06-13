class ImportTransactionsController < ApplicationController
  require 'csv'
  
  def open_file
    @budget = Budget.find(params[:budget_id])
  end

  def process_file
    @budget = Budget.find(params[:budget_id])
    session[:budget_id] = @budget.id 
    
    ImportedTransaction.destroy_all
    account_id = params[:account_id]
    
    CSV.foreach(params[:file].path, headers: false) do |row|
      imported_transaction, payee, credit, debit, category_id, payee_id = nil
      payee = Payee.find_by_description(row[5])
      
      unless row[0].nil?
        unless payee.nil?
          payee_id = payee.id
          category_id= payee.category.id
        end
        if row[1].to_f > 0
          credit = row[1].to_f
          puts credit
        else
          debit = row[1].to_f
          puts debit
        end    
        
        imported_transaction = ImportedTransaction.new(raw_data: row.to_s, credit: credit, debit: debit, txn_date: Date.strptime(row[0].to_s,"%e-%b-%y"),
         description: row[5], balance: row[6], account_id: account_id, payee_id: payee_id, category_id: category_id)
      
        budget_transaction = BudgetTransaction.find_by_raw_data(row.to_s)
      
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
            manual: false, scheduled: false, budgeted: is_budgeted,miscellaneous: misc,savings: false,reconciled: false)
            
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
