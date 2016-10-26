class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy, :complete_task, :complete_task_widget]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.open.order(created_at: :desc)
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
    @budget = Budget.find(params[:budget_id])
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to request.referer, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        @tasks = Task.open.order(created_at: :desc)
        format.html {
          flash[:error] = "The task could not be saved. Please enter mandatory information."
          render :index , locals: {tasks: @tasks}
        }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def complete_task
    unless (params[:completed].nil?)
      @task.update_attribute(:completed,params[:completed])
    end

    @tasks = Task.open.order(created_at: :desc)

    respond_to do |format|
      format.js
    end

  end

  def complete_task_widget
    unless (params[:budget_id].nil?)
      @budget = Budget.find(params["budget_id"])
      @tasks = Task.open.where('budget_id = ?',@budget.id).order(created_at: :desc)
    end
    unless (params[:completed].nil?)
      @task.update_attribute(:completed,params[:completed])
    end

    respond_to do |format|
      format.js
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:description, :due_by, :completed, :budget_id,:title,:priority)
    end
end
