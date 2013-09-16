class EntriesController < ApplicationController

	def new
    @entry = GratefulnessEntry.new
	end

  def show
    @entry = GratefulnessEntry.find_by_id(params[:id]) || not_found
  end

end
