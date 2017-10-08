class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy, :update_progress, :close]

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
    @top_5_misc_master_categories = BudgetTransaction.total_miscellaneous_grouped_by_master_category(@budget.id,5)
    @top_5_misc_categories = BudgetTransaction.total_miscellaneous_grouped_by_category(@budget.id,5)
    @top_5_payees = BudgetTransaction.total_grouped_by_external_payee(@budget.id,5)
    @tasks = Task.open.where('budget_id = ?',@budget.id).order(created_at: :desc).limit(3)

    #Budget Dashboard Elements
    @budgeted_amount = @budget.budgeted_amount
    @income = @budget.income
    @savings = @budget.savings

    @expenses = @budget.expenses
    @miscellaneous_expenses = @misc_budget_item.expenses #@budget.miscellaneous_expenses
    @savings_expenses = @budget.savings_expenses

    @income_remaining = @budget.income_remaining
    @expenses_remaining = @budget.expenses_remaining


    @budget_consumption = @budget.budget_consumption_percentage
    @income_consumption = @budget.income_consumption_percentage


    @days_remaining = @budget.days_remaining

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

  def close
    @budget.clear_budget_accounts
    @budget.is_closed = true

    respond_to do |format|
      if @budget.save
        NetWorth.capture_net_worth_for_budget(@budget)
        format.html { redirect_to @budget, notice: 'Budget was successfully closed.' }
        format.json { render :show, status: :ok, location: @budget }
      else
        format.html { render :edit }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = Budget.find(params[:id])
      session[:budget_id] = @budget.id
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_params
      params.require(:budget).permit(:year, :month, :start_date, :end_date)
    end
end
