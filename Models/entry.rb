class Entry

	attr_writer :id, :author_id, :date_created, :items

	def to_s
		"#{@id} - #{@date_created} - by #{@author_id}"
	end

end
