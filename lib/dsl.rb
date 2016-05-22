require_relative "snowball"

module Snowball
  module DSL

    def bot
      return @bot unless @bot.nil?
      @bot = Snowball::TwitterBot.new
    end

    def slackbot
      return @slackbot unless @slackbot.nil?
      @slackbot = Snowball::SlackBot.new
    end

    def debug_mode(d=nil)
      d = true if d.nil?
      bot.debug_mode = d
    end

    def use_slack(s=nil)
      s = true if s.nil?
      bot.use_slack = s
    end

    def use_streaming(s=nil)
      s = true if s.nil?
      bot.use_streaming = s
    end

    def use_multi_client(m=nil)
      m = true if m.nil?
      bot.use_multi_client = m
    end

    def on_streaming(&block)
      bot.register_handler(:on_streaming, &block)
    end

    def command(cmd, &block)
      bot.register_handler(:command, cmd, &block)
    end

    def registered_command(cmd, &block)
      bot.register_handler(:registered_command, cmd, &block)
    end

    def protected_command(cmd, &block)
      bot.register_handler(:protected_command, cmd, &block)
    end

    def on_message(&block)
      slackbot.register_handler(:on_message, &block)
    end

    def slack_command(cmd, &block)
      slackbot.register_handler(:command, cmd, &block)
    end

  end
end

include Snowball::DSL



