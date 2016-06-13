class BudgetItemsController < ApplicationController
  before_action :set_butget_item, only: [:show, :edit, :update]
  
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
