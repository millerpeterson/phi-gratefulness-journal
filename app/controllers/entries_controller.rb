class EntriesController < ApplicationController

	def new
    @entry = GratefulnessEntry.new
	end

end
