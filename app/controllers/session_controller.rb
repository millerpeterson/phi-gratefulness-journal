class SessionController < ApplicationController

  skip_before_filter :require_login, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to new_entry_path
    else
      flash[:invalid_login] = t('login.error-invalid-creds')
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, :notice => "Logged out!"
  end

end
