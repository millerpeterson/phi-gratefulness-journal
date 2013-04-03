class AppConfig

	private_class_method :new
	@@config = nil

	attr_reader :instance_code

	def AppConfig.create()
		if not @@config
			@@config = new
		end
		@@config
	end

	def initialize()
		@instance_code = 'test1'
	end

end