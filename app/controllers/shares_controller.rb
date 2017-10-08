class SharesController < ApplicationController
  layout "admin", only: [:new, :edit,:create,:update]
  before_action :set_share, only: [:show, :edit, :update, :destroy, :sell_share,:complete_share_sale]

  # GET /shares
  # GET /shares.json
  def index
    @shares = Share.all.active
    @sold_shares = Share.all.sold

    @shares_with_details = Array.new
    @total_market_value = 0
    @total_change_value = 0
    @total_proft_loss = 0
    @total_daily_movement_percentage = 0

    @shares.each do |share|
      share.set_share_details
      details = Hash.new
      details['share'] = share
      details['market_value'] = share.get_holding_value
      @total_market_value += details['market_value']
      details['change_value'] = share.get_percent_change_value
      @total_change_value += details['change_value']
      details['purchase_cost'] = share.get_purchase_cost
      details['profit_loss_value'] = share.get_profit_loss_value
      @total_proft_loss += details['profit_loss_value']
      details['profit_loss_percentage'] = share.get_profit_loss_percentage
      percentage_change = 0
      percentage_change = share.share_details["cp"].to_f unless share.share_details.nil?
      details['daily_movement_percentage'] = percentage_change
      @shares_with_details << details
    end
    if @total_change_value > 0
      @total_daily_movement_percentage = ((@total_change_value/@total_market_value)*100).to_f.round(2)
    end
  end

  # GET /shares/1
  # GET /shares/1.json
  def show
    @share.set_share_details
  end

  # GET /shares/new
  def new
    @share = Share.new
  end

  # GET /shares/1/edit
  def edit
  end

  # POST /shares
  # POST /shares.json
  def create
    @share = Share.new(share_params)

    respond_to do |format|
      if @share.save!
        format.html { redirect_to @share, notice: 'Share was successfully created.' }
        format.json { render :show, status: :created, location: @share }
      else
        format.html { render :new }
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shares/1
  # PATCH/PUT /shares/1.json
  def update
    respond_to do |format|
      if @share.update(share_params)
        format.html { redirect_to @share, notice: 'Share was successfully updated.' }
        format.json { render :show, status: :ok, location: @share }
      else
        format.html { render :edit }
        format.json { render json: @share.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shares/1
  # DELETE /shares/1.json
  def destroy
    @share.destroy
    respond_to do |format|
      format.html { redirect_to shares_url, notice: 'Share was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def sell_share

  end

  def complete_share_sale
    ActiveRecord::Base.transaction(requires_new: true) do
      respond_to do |format|
          begin
            if (params[:share][:sell_price].nil? || params[:share][:sell_price] == "") || (params[:share][:sell_price].nil? || params[:share][:sell_price] == "")
              raise 'unable to undate share record as sell price or sell date is not valid'
              @share.errors.add(:name, "Unable to undate share record as sell price or sell date is not valid")
            end

            total_sale_price = @share.units * params[:share][:sell_price].to_f
            comment = "Sold "+@share.units.to_s+ " "+@share.name+" shares for $"+total_sale_price.to_s

            budget_id = nil
            if !session[:budget_id].nil?
              budget_id = session[:budget_id]
            end

            # brokerage_account_payee = Account.find(@share.brokerage_account.id).payee
            payee = Payee.find_by_name("Share Purchase")
            BudgetTransaction.create!(account_id: @share.brokerage_account.id,payee_id: payee.id,
              budget_id: budget_id,category_id: Category.find_by_name("Investment").id, credit: total_sale_price,
              transaction_date: params[:share][:sell_date], comments: comment,reconciled: true, share_id: @share.id,share: true,miscellaneous: false)

            unless @share.update(share_params)
              raise 'unable to undate share record for sale'
              @share.errors.add(:name, "Unable to update share record for sale")
            end

            @share.set_share_details
            format.html
          rescue Exception => errs
            @share.errors.add(:name, "Unable to sell stock : "+errs.to_s)
            raise ActiveRecord::Rollback
            @share.set_share_details
            format.html { render :sell_share }
          end
      end
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_share
      @share = Share.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def share_params
      params.require(:share).permit(:name, :code, :share_type, :units, :purchase_price, :purchase_date, :last_price, :sell_price, :sell_date, :brokerage_account_id, :no_cash_transaction)
    end
end
