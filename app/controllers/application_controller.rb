class ApplicationController < ActionController::Base

  protect_from_forgery

  layout 'one-column'

  helper_method :current_user_session, :current_user

  private

    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = I18n.t('application.must-be-logged-in')
        redirect_to new_user_session_path
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = I18n.t('application.must-be-logged-out')
        redirect_to home_path
        return false
      end
    end

    def store_location
      session[:return_to] = request.url
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    def not_found
      status_code_response(404, :not_found)
    end

    def no_access
      status_code_response(403, :forbidden)
    end

    def unprocessable
      status_code_response(422, :unprocessable_entity)
    end

    def status_code_response(code, status)
      render file: File.join(Rails.root, "public/#{code}"),
             formats: [:html],
             status: status,
             layout: false
    end

end
