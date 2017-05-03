class DashboardController < ApplicationController
  layout "dashboard"
  before_action :set_net_worth

  def index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_net_worth
      @net_worth = net_worth_details
    end

end
