class ApplicationBaseDeviseController < ActionController::Base
  layout "devise"
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :first_name,:last_name,:email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :first_name,:last_name,:email, :password, :current_password])
  end
end
