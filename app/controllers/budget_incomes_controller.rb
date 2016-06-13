class BudgetIncomesController < ApplicationController
  before_action :set_budget_income, only: [:show, :edit, :update, :destroy]

  # GET /budget_incomes
  # GET /budget_incomes.json
  def index
    @budget_incomes = BudgetIncome.all
  end

  # GET /budget_incomes/1
  # GET /budget_incomes/1.json
  def show
  end

  # GET /budget_incomes/new
  def new
    @budget_income = BudgetIncome.new
    
    unless params[:budget_id].nil?
      @budget_income.budget_id = params[:budget_id].to_i
    end
  end

  # GET /budget_incomes/1/edit
  def edit
  end

  # POST /budget_incomes
  # POST /budget_incomes.json
  def create
    @budget_income = BudgetIncome.new(budget_income_params)

    respond_to do |format|
      if @budget_income.save
        format.html { redirect_to @budget_income.budget, notice: 'Budget income was successfully created.' }
        format.json { render :show, status: :created, location: @budget_income }
      else
        format.html { render :new }
        format.json { render json: @budget_income.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /budget_incomes/1
  # PATCH/PUT /budget_incomes/1.json
  def update
    respond_to do |format|
      if @budget_income.update(budget_income_params)
        format.html { redirect_to @budget_income.budget, notice: 'Budget income was successfully updated.' }
        format.json { render :show, status: :ok, location: @budget_income }
      else
        format.html { render :edit }
        format.json { render json: @budget_income.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /budget_incomes/1
  # DELETE /budget_incomes/1.json
  def destroy
    @budget_income.destroy
    respond_to do |format|
      format.html { redirect_to budget_incomes_url, notice: 'Budget income was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def show_income_splits
    @budget_income = BudgetIncome.find(params[:id])
    @income_splits = IncomeSplit.where("budget_id = ? and income_id = ?",@budget_income.budget.id,@budget_income.income.id)
    
    if @income_splits.nil? || @income_splits.count < 1
      @budget_income.auto_generate_income_splits
      @income_splits = IncomeSplit.where("budget_id = ? and income_id = ?",@budget_income.budget.id,@budget_income.income.id)
    end
    
    respond_to do |format|
      format.js
    end
  end

  def generate_income_splits
    @budget_income = BudgetIncome.find(params[:id])
    @budget_income.generate_income_splits(params[:first_income_date].to_date,params[:amount].to_f)
    @income_splits = IncomeSplit.where("budget_id = ? and income_id = ?",@budget_income.budget.id,@budget_income.income.id)
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget_income
      @budget_income = BudgetIncome.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_income_params
      params.require(:budget_income).permit(:description, :amount, :budget_id, :account_id)
    end
end
