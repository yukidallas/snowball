require 'yaml'
require 'dotenv'
require 'twitter'
Dotenv.load

Process.daemon(true,true)
pid_file = "snowball.pid"
open(pid_file, 'w') {|f| f << Process.pid} if pid_file

Thread.abort_on_exception = true

module Snowball
  def self.load
    require_relative "config"
    require_relative "db"
    require_relative "client"
    require_relative "logging"
    require_relative "tweet"
    require_relative "streaming"
    require_relative "slack_actions"

    require_relative "slackbot"
    require_relative "bot"
    puts "module loaded."
  end
end

Snowball.load