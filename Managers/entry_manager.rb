require_relative '../Models/entry'
require_relative './simpledb_manager'

require 'Date'
require 'SecureRandom'

class EntryManager < SimpleDBManager

	def get(id)
		entry = Entry.new
		entry.id = SecureRandom.uuid
		entry.author_id = -1
		entry.date_created = DateTime.now
		entry.items = []
		return entry
	end

	def save(entry)
		return true
	end

end