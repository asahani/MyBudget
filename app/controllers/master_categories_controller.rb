class MasterCategoriesController < ApplicationController
  layout "admin"
  before_action :set_master_category, only: [:show, :edit, :update, :destroy]

  # GET /master_categories
  # GET /master_categories.json
  def index
    @master_categories = MasterCategory.all.non_system
  end

  # GET /master_categories/1
  # GET /master_categories/1.json
  def show
  end

  # GET /master_categories/new
  def new
    @master_category = MasterCategory.new
  end

  # GET /master_categories/1/edit
  def edit
  end

  # POST /master_categories
  # POST /master_categories.json
  def create
    @master_category = MasterCategory.new(master_category_params)

    respond_to do |format|
      if @master_category.save
        format.html { redirect_to master_categories_url, notice: 'Master category was successfully created.' }
        format.json { render :show, status: :created, location: @master_category }
      else
        format.html { render :new }
        format.json { render json: @master_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_categories/1
  # PATCH/PUT /master_categories/1.json
  def update
    respond_to do |format|
      if @master_category.update(master_category_params)
        format.html { redirect_to master_categories_url, notice: 'Master category was successfully updated.' }
        format.json { render :show, status: :ok, location: @master_category }
      else
        format.html { render :edit }
        format.json { render json: @master_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_categories/1
  # DELETE /master_categories/1.json
  def destroy
    @master_category.destroy
    respond_to do |format|
      format.html { redirect_to master_categories_url, notice: 'Master category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_master_category
      @master_category = MasterCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_category_params
      params.require(:master_category).permit(:name, :icon, :active)
    end
end
