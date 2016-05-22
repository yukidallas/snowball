require 'slack'
require 'net/http'

module Snowball
  class SlackBot
    include Config

    def initialize
      @config = load_config
      setup_variable
    end

    def register_handler(method_type, cmd=nil, &block)
      @plugin_quantity += 1
      case method_type
      when :on_message
        @on_message << block
      when :command
        @commands[cmd] ||= []
        @commands[cmd] << block
      end
    end

    def run!
      puts information

      slack_client.on :message do |obj|
        message = Slack::Message.new(config[:slack],obj)
        extract(message)
      end
      slack_client.start
    end

private

    def setup_variable
      @plugin_quantity = 0
      @on_message = []
      @commands = {}
    end

    def information
"\n------- Slack Bot -------
 Available plugins: #{@plugin_quantity}
-------------------------\n"
    end

    def slack_client
      @slack_client ||= Slack::Client.new(token: config[:slack]["token"]).realtime
    end

    def extract(message)
      case message.channel
      when config[:slack]["general"]
        on_message.each do |proc|
          proc.call message
        end
        command_callback(message)
      when config["notification"]
      end
    end

    def command_callback(message)
      commands.each do |cmd, procs|
        next unless message.text =~ /^<@#{slack_id}>:?\s*#{cmd}/i
        message.args = [$1,$2,$3,$4,$5]
        procs.each {|proc|proc.call message}
      end
    end

    def on_message
      @on_message end

    def commands
      @commands end

  end
end

module Slack
  class Notifier
    include Actions

    def initialize(params={})
      @config = params
    end

  end
end