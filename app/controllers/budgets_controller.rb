class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy, :update_progress]

  # GET /budgets
  # GET /budgets.json
  def index
    month_start_day = Rails.application.config.start_of_the_month
    year = Time.now.year
    month = Time.now.month

    month_start_date = Date.new(year,month,month_start_day)
    if Time.now < month_start_date
      if month == 1
        month = 12
        year = year-1
      else
        month = month-1
      end
    end

    @budget = Budget.find_by_year_and_month(year,month)

    if @budget.nil?
      redirect_to :action => :new, :year => year, :month => month
    else
      redirect_to @budget
    end
  end

  # GET /budgets/1
  # GET /budgets/1.json
  def show
    # @misc_budget_item = BudgetItem.find_by_budget_id_and_category_id(@budget.id,Category.find_by_miscellaneous_and_mandatory(true,true).id)
    @misc_budget_item = @budget.budget_items.joins(:category).where("categories.name = ?","Miscellaneous").first
    @tasks = Task.open.where('budget_id = ?',@budget.id).order(created_at: :desc).limit(3)

    #Budget Dashboard Elements
    @budget_consumption = 0
    @income_consumption = 0

    @budgeted_amount = @budget.budget_items.sum(:budgeted_amount)
    @income = @budget.budget_incomes.sum(:amount)
    @savings = @budget.budget_transactions.savings_transactions.sum(:credit)

    @expenses = @budget.budget_items.sum(:expenses)
    @miscellaneous_expenses = @budget.budget_transactions.miscellaneous_transactions.sum(:debit)
    @savings_expenses = @budget.budget_transactions.savings_expense_transactions.sum(:debit)

    @income_remaining = @income - (@expenses+@savings)
    @expenses_remaining = @budget.budget_items.where("balance > 0").sum(:balance)
    
    if (@expenses > 0)
      @budget_consumption = ((@expenses/@budgeted_amount)*100).to_i
      @income_consumption = ((@expenses/@income)*100).to_i
    end

    @days_remaining = (@budget.end_date.to_date - Time.now.to_date).to_i
    if Time.now.to_date >= @budget.end_date
      @days_remaining = 0
    end

  end

  # GET /budgets/1
  # GET /budgets/1.json
  def show_or_create
    year = params[:year].to_i

    if year == 0
      month_start_day = Rails.application.config.start_of_the_month
      year = Time.now.year
      month = Time.now.month

      month_start_date = Date.new(year,month,month_start_day)
      if Time.now < month_start_date
        if month == 1
          month = 12
          year = year-1
        else
          month = month-1
        end
      end
    end

    month = params[:month].to_i

    @budget = Budget.find_by_year_and_month(year,month)

    if @budget.nil?
      redirect_to :action => :new, :year => year, :month => month
    else
      redirect_to @budget
    end
  end

  # GET /budgets/new
  def new
    @budget = Budget.new
  end

  # GET /budgets/1/edit
  def edit
  end

  # POST /budgets
  # POST /budgets.json
  def create
    month_start_day = Rails.application.config.start_of_the_month
    start_date = Date.new(params[:year].to_i,params[:month].to_i,month_start_day)
    end_date = start_date.next_month.prev_day

    @budget = Budget.new(year: params[:year].to_i,month: params[:month].to_i,start_date: start_date,end_date: end_date)

    respond_to do |format|
        begin
          @budget.save
          format.html { redirect_to @budget, notice: 'Budget was successfully created.' }
          format.json { render :show, status: :created, location: @budget }
        rescue Exception => exec
          @budget.errors.add(:budget_items,exec.message)
          format.html { render :new }
          format.json { render json: @budget.errors, status: :unprocessable_entity }
        end
    end
  end

  # PATCH/PUT /budgets/1
  # PATCH/PUT /budgets/1.json
  def update
    respond_to do |format|
      if @budget.update(budget_params)
        format.html { redirect_to @budget, notice: 'Budget was successfully updated.' }
        format.json { render :show, status: :ok, location: @budget }
      else
        format.html { render :edit }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.json
  def destroy
    @budget.destroy
    respond_to do |format|
      format.html { redirect_to budgets_url, notice: 'Budget was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def update_progress
    budget_account = BudgetAccount.find(params[:budget_account_id])

    unless (params[:is_paid].nil?)
      budget_account.update_attribute(:paid,params[:is_paid])
    end

    unless (params[:is_reconciled].nil?)
      budget_account.update_attribute(:reconciled,params[:is_reconciled])
    end

    unless (params[:is_documented].nil?)
      budget_account.update_attribute(:documented,params[:is_documented])
    end

    unless (params[:statement_balance].nil?)
      budget_account.update_attribute(:statement_balance,params[:statement_balance].to_f)
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = Budget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_params
      params.require(:budget).permit(:year, :month, :start_date, :end_date)
    end
end
