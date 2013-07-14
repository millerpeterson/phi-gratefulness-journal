class ApplicationController < ActionController::Base

  protect_from_forgery

  layout 'three_column'

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    helper_method :current_user

end
