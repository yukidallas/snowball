module Snowball
  module Logging

    def debug(e)
      backtrace = "#{e.backtrace[0]}"
      logger.debug "#{backtrace}:\s#{e}"
    end

protected

    def logger
      return @logger unless @logger.nil?
      @logger ||= Logger.new("./log/snowball.log", "weekly")
      logger_config
      return @logger
    end

    def logger_config
      @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
      @logger.formatter = proc{|severity, datetime, progname, message|
        "[#{severity}] #{datetime}: #{message}\n"
      }
    end

  end
end