class CategoriesController < ApplicationController
  layout "admin", only: [:index, :new, :edit]
  before_action :set_category, only: [:show, :edit, :update, :destroy,:edit_transaction_category,:select_transaction_category]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all.non_system
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit_transaction_category
    @txn = ImportedTransaction.find(params[:imported_txn_id])
  end

  def select_transaction_category
    respond_to do |format|
      unless params[:imported_txn_id].nil?
        imported_txn = ImportedTransaction.find(params[:imported_txn_id])
        imported_txn.update(category_id: @category.id)
        format.js { render '/import_transactions/preview'}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :active, :budget_amount)
    end
end
