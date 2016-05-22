require_relative "lib/dsl"

#Load plugins
Dir.glob("plugin/*.rb").each do |plugin|
  require_relative plugin
end

#debug_mode

#use_multi_client

# begin
#   Thread.new {slackbot.run!}
#   bot.run!
# rescue => e
#   Snowball.slack.alert("例外が発生し、プロセスが終了しました。","#{e}","danger")
#   @logger ||= Logger.new("./log/snowball.log", "weekly")
#       @logger.datetime_format = "%Y-%m-%d %H:%M:%S"
#       @logger.formatter = proc{|severity, datetime, progname, message|
#         "[#{severity}] #{datetime}: #{message}\n"
#       }
#       backtrace = "#{e.backtrace[0]}"
#       @logger.debug "#{backtrace}:\s#{e}"
# else
#   Snowball.slack.notice("プロセスが終了しました。")
# end

# system("./snowball stop")
bot.run!