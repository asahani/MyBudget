class PayeesController < ApplicationController
  before_action :set_payee, only: [:show, :edit, :update, :destroy,:select_payee]

  # GET /payees
  # GET /payees.json
  def index
    @payees = Payee.all
  end

  # GET /payees/1
  # GET /payees/1.json
  def show
  end

  # GET /payees/new
  def new
    @payee = Payee.new
    @payee.called_from_import_txn = params[:called_from_import_txn]
    
    unless params[:imported_txn_id].nil?
      imported_txn = ImportedTransaction.find(params[:imported_txn_id])
      @payee.description = imported_txn.description
    end
  end

  # GET /payees/1/edit
  def edit
  end

  # POST /payees
  # POST /payees.json
  def create
    @payee = Payee.new(payee_params)
    
    if @payee.called_from_import_txn
      respond_to do |format|
        if @payee.save
          ImportedTransaction.where('description = ? ', @payee.description).update_all(payee_id: @payee.id,category_id: @payee.category.id)
          format.js { render '/import_transactions/preview'}
        end  
      end
    else
      respond_to do |format|
        if @payee.save
          @imported_transactions = ImportedTransaction.all
          format.html { redirect_to @payee, notice: 'Payee was successfully created.' }
          format.json { render :show, status: :created, location: @payee }
          format.js
        else
          format.html { render :new }
          format.json { render json: @payee.errors, status: :unprocessable_entity }
          format.js
        end
      end
    end
  end

  # PATCH/PUT /payees/1
  # PATCH/PUT /payees/1.json
  def update
    respond_to do |format|
      if @payee.update(payee_params)
        format.html { redirect_to @payee, notice: 'Payee was successfully updated.' }
        format.json { render :show, status: :ok, location: @payee }
      else
        format.html { render :edit }
        format.json { render json: @payee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payees/1
  # DELETE /payees/1.json
  def destroy
    @payee.destroy
    respond_to do |format|
      format.html { redirect_to payees_url, notice: 'Payee was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def select_payee
      respond_to do |format|
        unless params[:imported_txn_id].nil?
          imported_txn = ImportedTransaction.find(params[:imported_txn_id])
          payee_description = PayeeDescription.new(:description => imported_txn.description, :payee_id => @payee.id)

          if @payee.save!
            payee_description.save!
            ImportedTransaction.where('description = ? ', payee_description.description).update_all(payee_id: @payee.id,category_id: @payee.category.id)
            format.js { render '/import_transactions/preview'}
          end 
        end 
      end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_payee
      @payee = Payee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def payee_params
      params.require(:payee).permit(:name, :description, :category_id,:is_account,:account_id,:called_from_import_txn)
    end
end
