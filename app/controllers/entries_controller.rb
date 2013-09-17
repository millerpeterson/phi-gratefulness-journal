class EntriesController < ApplicationController

  before_filter :require_user
  before_filter :verify_user_path
  before_filter :get_entry, only: [:show]
  before_filter :require_ownership, only: [:show]

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
    not_found if @entry.nil?
  end

  private

    def verify_user_path
      no_access if User.find_by_id(params[:user_id]) != current_user
    end

    def get_entry
      @entry = GratefulnessEntry.find_by_id(params[:id])
    end

    def require_ownership
      no_access if @entry.try(:author) != current_user
    end

end
