class EntriesController < ApplicationController

  before_filter :require_user
  before_filter :verify_user_path

	def new
    @entry = GratefulnessEntry.new
	end

  def create
    @entry = GratefulnessEntry.new(params[:gratefulness_entry])
    @entry.creation_date = DateTime.now
    @entry.author = current_user
    if @entry.save
      redirect_to user_entry_path(current_user, @entry)
    end
  end

  def show
    get_entry!
    check_ownership_and_existence
  end

  def random
    get_random_entry!
    check_ownership_and_existence
    redirect_to user_entry_path(current_user, @entry)
  end

  def recent
    get_last_entry!
    check_ownership_and_existence
    redirect_to user_entry_path(current_user, @entry)
  end

  def index
    if params[:random].present?
      get_random_entry!
      render 'entries/show'
    elsif params[:recent].present?
      get_last_entry!
      render 'entries/show'
    else
      redirect_to new_user_entry_path(current_user)
    end
  end

  private

    def check_ownership_and_existence
      require_ownership
      not_found if @entry.nil?
    end

    def verify_user_path
      no_access if User.find_by_id(params[:user_id]) != current_user
    end

    def get_entry!
      @entry = GratefulnessEntry.find_by_id(params[:id])
    end

    def get_last_entry!
      @entry = GratefulnessEntry.previous_entry(DateTime.now)
    end

    def get_random_entry!
      offset = rand(GratefulnessEntry.count)
      @entry = GratefulnessEntry.first(:offset => offset)
    end

    def require_ownership
      no_access if @entry.try(:author) != current_user
    end

end
