require 'yaml'
require 'aws-sdk'
require_relative '../Models/log'
require_relative '../Models/app_config'

class SimpleDBManager

	@@aws_config_file_path = '/Users/miller/Gratefulness/aws-config.yaml'
	@@app_config_file_path = '/Users/miller/Gratefulness/app-config.yaml'

	@@app_config = nil
	@@aws_client = nil	

	# Singleton.
	private_class_method :new
	@@manager = nil

	def SimpleDBManager.create()
		if not @@manager
			if (@@aws_client == nil)
				SimpleDBManager.configureAws(@@aws_config_file_path)
				@@app_config = AppConfig.create()
			end
			@@manager = new	
		end
		@@manager
	end

	def SimpleDBManager.configure_aws(config_file)
		# TODO: cache this somehow.
		config = YAML.load(File.read(config_file))	
		AWS.config(config)
		@@aws_client = AWS::SimpleDB.new
	end	

	def initialize()
		@model_name = 'dummy'
		@@model_aws_domain = "%s_%s" % [@@app_config.instance_code, @model_name]			
		puts @@model_aws_domain
		@domain = @@aws_client.domains[@@model_aws_domain]
		if not @domain.exists?			
			@aws_client.domains.create(@@model_aws_domain)
			@domain  = @@aws_client.domains[@@model_aws_domain]
			# TODO: error if @domain does not exist.
		end
	end

	end

end