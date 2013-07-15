class EntriesController < ApplicationController

	def new
    render action: 'new_gratefulness'
	end

  def new_gratefulness
    @entry = Entry.new
    render template: 'entries/new_gratefulness'
  end

end
