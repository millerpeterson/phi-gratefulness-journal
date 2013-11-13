class UsersController < ApplicationController

  before_filter :require_no_user, only: [:new, :create]

  def new
    @user ||= User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = I18n.t('application.account-registered')
      redirect_back_or_default home_path
    else
      render :action => :new
    end
  end

  def show
    not_found
  end

  def edit
    not_found
  end

  def update
    not_found
  end

end