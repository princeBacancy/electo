# frozen_string_literal: true

# all other controller extends this controller
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[user_name first_name
                                                         last_name gender
                                                         birth_date])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[user_name
                                                                first_name
                                                                last_name
                                                                gender
                                                                birth_date])
  end
end
