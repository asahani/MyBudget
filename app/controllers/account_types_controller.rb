class AccountTypesController < ApplicationController
  before_action :set_account_type, only: [:show, :edit, :update, :destroy]

  # GET /account_types
  # GET /account_types.json
  def index
    @account_types = AccountType.all
  end

  # GET /account_types/1
  # GET /account_types/1.json
  def show
  end

  # GET /account_types/new
  def new
    @account_type = AccountType.new
  end

  # GET /account_types/1/edit
  def edit
  end

  # POST /account_types
  # POST /account_types.json
  def create
    @account_type = AccountType.new(account_type_params)

    respond_to do |format|
      if @account_type.save
        format.html { redirect_to @account_type, notice: 'Account type was successfully created.' }
        format.json { render :show, status: :created, location: @account_type }
      else
        format.html { render :new }
        format.json { render json: @account_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /account_types/1
  # PATCH/PUT /account_types/1.json
  def update
    respond_to do |format|
      if @account_type.update(account_type_params)
        format.html { redirect_to @account_type, notice: 'Account type was successfully updated.' }
        format.json { render :show, status: :ok, location: @account_type }
      else
        format.html { render :edit }
        format.json { render json: @account_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /account_types/1
  # DELETE /account_types/1.json
  def destroy
    @account_type.destroy
    respond_to do |format|
      format.html { redirect_to account_types_url, notice: 'Account type was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account_type
      @account_type = AccountType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_type_params
      params.require(:account_type).permit(:type, :budget_account)
    end
end
