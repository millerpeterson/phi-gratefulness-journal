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
    else
      unprocessable
    end
  end

  def show
    get_entry!
    not_found and return if @entry.nil?
    no_access if !entry_owned?
  end

  def random
    get_random_entry!
    not_found and return if @entry.nil?
    no_access and return if !entry_owned?
    redirect_to user_entry_path(current_user, @entry)
  end

  def recent
    get_last_entry!
    not_found and return if @entry.nil?
    no_access and return if !entry_owned?
    redirect_to user_entry_path(current_user, @entry)
  end

  def index
    redirect_to new_user_entry_path(current_user)
  end

  private

    def verify_user_path
      no_access if User.find_by_id(params[:user_id]) != current_user
    end

    def get_entry!
      @entry = GratefulnessEntry.find_by_id(params[:id])
    end

    def get_last_entry!
      @entry = GratefulnessEntry.previous_entry(current_user, DateTime.now)
    end

    def get_random_entry!
      offset = rand(current_user.entries.count)
      @entry = current_user.entries.first(offset: offset)
    end

    def entry_owned?
      @entry.try(:author) == current_user
    end

end
