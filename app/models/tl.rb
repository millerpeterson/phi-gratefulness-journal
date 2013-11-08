class Tl

  @@logger = ActiveSupport::TaggedLogging.new(Logger.new("#{Rails.root}/log/development_trace.log"))

  def log(message)
    @@logger.tagged(Time.now.strftime("%Y-%m-%d %H:%M:%S")) { @@logger.info(message) }
  end

end