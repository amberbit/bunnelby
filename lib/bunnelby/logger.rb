module Bunnelby::Logger
  def log(message)
    if defined?(Rails)
      Rails.logger.info message
    else
      puts message
    end
  end

  def log_exception(e)
    if defined?(Rollbar)
      Rollbar.error(e)
    else
      Rails.logger.info "Exception: #{e.to_s}"
    end
  end
end
