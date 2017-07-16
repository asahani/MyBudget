class BudgetTransactionsController < ApplicationController
  before_action :set_budget_transaction, only: [:show, :edit, :update, :destroy, :edit_budget_item_transaction, :update_cleared_status]
respond_to :js, :html
  # GET /budget_transactions
  # GET /budget_transactions.json
  def index
    if params[:tag]
      @tag = params[:tag]
      @budget_transactions = BudgetTransaction.tagged_with(@tag)
      if params[:budget_id]
        @budget = Budget.find(params[:budget_id])
      end
    elsif !params[:budget_id].nil? && !params[:account_id].nil?
      @budget = Budget.find(params[:budget_id])
      @account = Account.find(params[:account_id])
      @budget_transactions = BudgetTransaction.where('budget_id =? and account_id = ?',@budget.id,@account.id)
      @budget_withdrawals = BudgetTransaction.where('budget_id = ? and payee_id = ?',@budget.id, @account.payee.id)
    elsif !params[:budget_id].nil?
      @budget = Budget.find(params[:budget_id])
      @budget_transactions = @budget.budget_transactions
    else
      @budget_transactions = BudgetTransaction.all
    end
  end

  # GET /budget_transactions/1
  # GET /budget_transactions/1.json
  def show
  end

  # GET /budget_transactions/new
  def new
    @budget_transaction = BudgetTransaction.new
    @budget_transaction.budgeted = false
    @budget_transaction.scheduled = false
    @budget_transaction.manual = true

    unless params[:budget_id].nil?
      @budget_transaction.budget_id = params[:budget_id].to_i
    end

    #TODO
    # This block can be deprecated
    if params[:tranasction_type] === "miscellaneous"
      @budget_transaction.miscellaneous = true
      @budget_transaction.savings = false
    elsif params[:tranasction_type] === "savings"
      @budget_transaction.miscellaneous = false
      @budget_transaction.savings = true
    end
  end

  # GET /budget_transactions/1/edit
  def edit
    @transaction_type = params[:transaction_type]

    respond_to do |format|
        format.js
    end
  end

  # GET /budget_transactions/1/edit_budget_item_transaction
  def edit_budget_item_transaction
    respond_to do |format|
        format.js
    end
  end

  # POST /budget_transactions
  # POST /budget_transactions.json
  def create
    @budget_transaction = BudgetTransaction.new(budget_transaction_params)
    
    if @budget_transaction.transaction_type == 'loan_transfer'
      @budget_transaction.category_id = Category.find_by_name("Lending").id
    else
      @budget_transaction.category_id = @budget_transaction.payee.category.id
    end

    if @budget_transaction.credit.nil?
      @budget_transaction.credit = 0.00
    end
    if @budget_transaction.debit.nil?
      @budget_transaction.debit = 0.00
    end

    # Set budget Item for non-budgeted transactions. This is for BudgetItems only
    if @budget_transaction.budget_item.nil?
      if !@budget_transaction.transaction_type.nil? && @budget_transaction.transaction_type == 'miscellaneous'
        @budget_item = BudgetItem.find_by_budget_id_and_category_id(
          @budget_transaction.budget.id,Category.find_by_miscellaneous_and_mandatory(true,true).id)
        @budget_transaction.budget_item = @budget_item
      end
    else
      @budget_item = @budget_transaction.budget_item
    end

    # Determine Misc vs Savings Transaction
    # unless @budget_transaction.budgeted
    #   if !@budget_transaction.transaction_type.nil? && @budget_transaction.transaction_type == 'miscellaneous'
    #     @budget_transaction.miscellaneous = true
    #     @budget_transaction.savings = false
    #   elsif !@budget_transaction.transaction_type.nil? && @budget_transaction.transaction_type == 'savings'
    #     @budget_transaction.miscellaneous = false
    #     @budget_transaction.savings = true
    #   end
    # end

    respond_to do |format|
      if @budget_transaction.save
        format.html { redirect_to @budget_transaction.budget, notice: 'Budget transaction was successfully created.' }
        format.json { render :show, status: :created, location: @budget_transaction }
        format.js
      else
        format.html { render :new }
        format.json { render json: @budget_transaction.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /budget_transactions/1
  # PATCH/PUT /budget_transactions/1.json
  def update
    @budget_transaction.category_id = @budget_transaction.payee.category.id
    @budget_item = @budget_transaction.budget_item

    # Determine Misc vs Savings Transaction
    # unless @budget_transaction.budgeted
    #   if !@budget_transaction.transaction_type.nil? && @budget_transaction.transaction_type == 'miscellaneous'
    #     @budget_transaction.miscellaneous = true
    #     @budget_transaction.savings = false
    #   elsif !@budget_transaction.transaction_type.nil? && @budget_transaction.transaction_type == 'savings'
    #     @budget_transaction.miscellaneous = false
    #     @budget_transaction.savings = true
    #   end
    # end

    respond_to do |format|
      if @budget_transaction.update(budget_transaction_params)
        format.js
        format.html { redirect_to @budget_transaction.budget, notice: 'Budget transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @budget_transaction }
      else
        format.js
        format.html { render :edit }
        format.json { render json: @budget_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /budget_transactions/1
  # DELETE /budget_transactions/1.json
  def destroy
    @budget_item = @budget_transaction.budget_item
    @budget_transaction.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to @budget_item.budget, notice: 'Budget transaction was successfully destroyed.' }
    end
  end

  def update_cleared_status
    reconciled = @budget_transaction.reconciled
    is_payee_account = params[:is_payee_account]

    @budget_transaction.update_attributes!(:reconciled => !reconciled)

    respond_to do |format|
      @budget = @budget_transaction.budget
      @account = @budget_transaction.account
      if is_payee_account == 'true'
        @budget_transactions = BudgetTransaction.where('budget_id =? and account_id = ?',@budget.id,@budget_transaction.payee.account.id)
        @budget_withdrawals = BudgetTransaction.where('budget_id = ? and payee_id = ?',@budget.id, @account.id)
      else
        @budget_transactions = BudgetTransaction.where('budget_id =? and account_id = ?',@budget.id,@account.id)
        @budget_withdrawals = BudgetTransaction.where('budget_id = ? and payee_id = ?',@budget.id, @account.payee.id)
      end
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_transaction
      @budget_transaction = BudgetTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_transaction_params
      params.require(:budget_transaction).permit(:credit, :debit, :transaction_date, :comments, :manual, :scheduled, :budgeted,
        :miscellaneous, :savings, :account_id, :budget_item_id, :budget_id,:payee_id,:category_id,:transaction_type,:reconciled,:tag_list)
    end
end
