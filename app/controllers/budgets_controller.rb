class BudgetsController < ApplicationController
  before_action :set_budget, only: [:show, :edit, :update, :destroy]

  # GET /budgets
  # GET /budgets.json
  def index
    #TODO: get Start Date from config
    month_start_day = 15
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
    @chart = LazyHighCharts::HighChart.new('graph') do |f|
          f.title({ :text=>"Combination chart"})
          f.options[:xAxis][:categories] = ['Apples', 'Oranges', 'Pears', 'Bananas', 'Plums']
          f.labels(:items=>[:html=>"Total fruit consumption", :style=>{:left=>"40px", :top=>"8px", :color=>"black"} ])
          f.series(:type=> 'column',:name=> 'Jane',:data=> [3, 2, 1, 3, 4])
          f.series(:type=> 'column',:name=> 'John',:data=> [2, 3, 5, 7, 6])
          f.series(:type=> 'column', :name=> 'Joe',:data=> [4, 3, 3, 9, 0])
          f.series(:type=> 'spline',:name=> 'Average', :data=> [3, 2.67, 3, 6.33, 3.33])
          f.series(:type=> 'pie',:name=> 'Total consumption',
            :data=> [
              {:name=> 'Jane', :y=> 13, :color=> 'red'},
              {:name=> 'John', :y=> 23,:color=> 'green'},
              {:name=> 'Joe', :y=> 19,:color=> 'blue'}
            ],
            :center=> [100, 80], :size=> 100, :showInLegend=> false)
        end

        @chart2 = LazyHighCharts::HighChart.new('pie') do |f|
              f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 200, 60, 170]} )
              series = {
                       :type=> 'pie',
                       :name=> 'Browser share',
                       :data=> [
                          ['Firefox',   45.0],
                          ['IE',       26.8],
                          {
                             :name=> 'Chrome',
                             :y=> 12.8,
                             :sliced=> true,
                             :selected=> true
                          },
                          ['Safari',    8.5],
                          ['Opera',     6.2],
                          ['Others',   0.7]
                       ]
              }
              f.series(series)
              f.options[:title][:text] = "THA PIE"
              f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'})
              f.plot_options(:pie=>{
                :allowPointSelect=>true,
                :cursor=>"pointer" ,
                :dataLabels=>{
                  :enabled=>true,
                  :color=>"black",
                  :style=>{
                    :font=>"13px Trebuchet MS, Verdana, sans-serif"
                  }
                }
              })
        end

        @chart3 = LazyHighCharts::HighChart.new('gauge') do |f|
                   f.chart(:defaultSeriesType => 'gauge',:type => 'gauge')
                   f.pane(:center => ['50%', '85%'],:size => '80%', :startAngle => -90, :endAngle => 90,
                    :background => {
                        :backgroundColor => '#EEE',
                        :innerRadius => '60%',
                        :outerRadius => '100%',
                        :shape => 'arc'
                    })
                   f.options[:yAxis] = {
                         :min => 0,:max => 100, :title => "speed",
                         :stops => [
                             [0.1, '#55BF3B'],
                             [0.5, '#DDDF0D'],
                             [0.9, '#DF5353']
                         ],
                         :lineWidth => 0,
                         :minorTickInterval => nil,
                         :tickPixelInterval => 400,
                         :tickWidth => 0,
                         :title => {
                             :y => -70
                         },
                         :labels => {
                             :y => 16
                         }
                     }
                   f.series(:type => 'gauge', :name=>'Correct',:data=> [80])
                   f.plot_options(:solidgauge => {
                       :dataLabels=> {:y => 5, :borderWidth => 0, :useHTML => true}
                    })
                end
    @misc_budget_item = BudgetItem.find_by_budget_id_and_category_id(@budget.id,Category.find_by_miscellaneous_and_mandatory(true,true).id)
  end

  # GET /budgets/1
  # GET /budgets/1.json
  def show_or_create
    year = params[:year].to_i

    if year == 0
      #TODO: get Start Date from config
      month_start_day = 15
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
    #TODO: get Start Date from config
    month_start_day = 15
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
