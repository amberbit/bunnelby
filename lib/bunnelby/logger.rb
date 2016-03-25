module Bunnelby::Logger
  def log(message)
    puts message

    if defined?(Rails)
      Rails.logger.info message
    end
  end
end
