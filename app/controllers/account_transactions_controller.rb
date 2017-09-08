class AccountTransactionsController < ApplicationController
  before_action :set_account_transaction, only: [:show, :edit, :update, :destroy]

  # GET /account_transactions
  # GET /account_transactions.json
  def index
    @account_transactions = AccountTransaction.all
  end

  # GET /account_transactions/1
  # GET /account_transactions/1.json
  def show
  end

  # GET /account_transactions/new
  def new
    @account_transaction = AccountTransaction.new
    unless params[:budget_id].nil?
      @account_transaction.budget_id = params[:budget_id].to_i
    else
      budget = Budget.where('start_date <= ? and end_date >= ?',Date.today,Date.today).first
      unless budget.nil?
        @account_transaction.budget_id = budget.id
      end
    end
  end

  # GET /account_transactions/1/edit
  def edit
  end

  # POST /account_transactions
  # POST /account_transactions.json
  def create
    @account_transaction = AccountTransaction.new(account_transaction_params)
    if @account_transaction.transaction_type == 'loan_transfer'
      @account_transaction.category_id = Category.find_by_name("Lending").id
    else
      @account_transaction.category_id = @account_transaction.payee.category.id
    end

    respond_to do |format|
      if @account_transaction.save
        format.html { redirect_to @account_transaction.budget, notice: 'Account transaction was successfully created.' }
        format.json { render :show, status: :created, location: @account_transaction }
        format.js
      else
        format.html { render :new }
        format.json { render json: @account_transaction.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /account_transactions/1
  # PATCH/PUT /account_transactions/1.json
  def update
    respond_to do |format|
      if @account_transaction.update(account_transaction_params)
        format.html { redirect_to @account_transaction, notice: 'Account transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_transaction }
      else
        format.html { render :edit }
        format.json { render json: @account_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_transactions/1
  # DELETE /account_transactions/1.json
  def destroy
    @account_transaction.destroy
    respond_to do |format|
      format.html { redirect_to account_transactions_url, notice: 'Account transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_transaction
      @account_transaction = AccountTransaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_transaction_params
      params.require(:account_transaction).permit(:tag_list, :account_id, :payee_id, :budget_id, :category_id, :amount, :transaction_date, :comments, :reconciled,:transaction_type,:historical_loan_transaction,:historical_account_transaction,:flagged)
    end
end
