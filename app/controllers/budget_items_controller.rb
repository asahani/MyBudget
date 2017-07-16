class BudgetItemsController < ApplicationController
  before_action :set_butget_item, only: [:show, :edit, :update,:one_click_transaction ]

  # GET /budget_items/1
  # GET /budget_items/1.json
  def show
    respond_to do |format|
        format.js
    end
  end

  # GET /budget_items/1/edit
  def edit
    @budget_item = BudgetItem.find(params[:id])
  end

  # PATCH/PUT /budget_items/1
  # PATCH/PUT /budget_items/1.json
  def update
    respond_to do |format|
      if @budget_item.update(budget_item_params)
        format.html { redirect_to @budget_item.budget, notice: 'Budget was successfully updated.' }
        format.json { render :show, status: :ok, location: @budget_item }
      else
        format.html { render :edit }
        format.json { render json: @budget_item.errors, status: :unprocessable_entity }
      end
    end

  end

  def one_click_transaction
    if @budget_item.category.has_template_transaction && !@budget_item.category.account_id.nil? && !@budget_item.category.payee_id.nil?
      budget_txn = BudgetTransaction.new(account_id: @budget_item.category.account_id, budget_item_id: @budget_item.id, payee_id: @budget_item.category.payee_id,
        budget_id: @budget_item.budget.id,category_id: @budget_item.category.id, credit: 0.00, debit: @budget_item.budgeted_amount,
        transaction_date: Time.now.to_date,comments: "1 click transaction",raw_data: nil,
        manual: true, scheduled: false, budgeted: true,miscellaneous: false, savings: false,reconciled: true)
        # TODO: not sure if scheduled should be false

      if budget_txn.save!
        @budget_item.complete = true
        @budget_item.payment_date = Time.now.to_date
      end
    end

    respond_to do |format|
      if @budget_item.save!
        format.html { redirect_to @budget_item.budget, notice: 'Budget was successfully updated.' }
        format.json { render :show, status: :ok, location: @budget_item }
      else
        format.html { render :edit }
        format.json { render json: @budget_item.errors, status: :unprocessable_entity }
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_butget_item
      @budget_item = BudgetItem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_item_params
      params.require(:budget_item).permit(:budgeted_amount, :payment_date, :comment, :complete)
    end

end
