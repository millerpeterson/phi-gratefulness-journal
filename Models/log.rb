require 'singleton'

class Log

	include Singleton

	def info(info_msg)
		puts info_msg
	end

end