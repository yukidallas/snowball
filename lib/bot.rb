module Snowball
  class TwitterBot
    include Config
    include Client
    include Logging
    # include Talk
    include Streaming

    alias :slack :slack_client

    def initialize
      @config = load_config
      setup_variable
    end

    def register_handler(method_type, cmd=nil, &block)
      @plugin_quantity += 1

      case method_type
      when :on_streaming
        @streaming_events << block
      when :command
        @commands[cmd] ||= []
        @commands[cmd] << block
      when :registered_command
        @registered_commands[cmd] ||= []
        @registered_commands[cmd] << block
      when :protected_command
        @protected_commands[cmd] ||= []
        @protected_commands[cmd] << block
      end
    end

    def run!
      information

      streaming_client.user(replies: 'all') do |obj|
        begin
          extract_timeline(obj)
        rescue Twitter::Error::TooManyRequests => e
          limitExceededError(e)
          retry
        end
      end
    end

private

    def setup_variable
      Snowball.rest(rest_client)
      Snowball.slack(slack_client)
      #For Plugins
      @plugin_quantity = 0
      @streaming_events = []
      @commands = {}
      @registered_commands = {}
      @protected_commands = {}
      #Prevent multiple read and write
      @archives = []
      @posted = []
    end

    def information
"\n------ Twitter Bot ------
 Available plugins: #{@plugin_quantity}
 Available accounts: #{rest_client.length}
-----------------------\n"
    end

    def limitExceededError(e)
      message = "Rate Limit Exceeded!"
      slack.alert(message,e)
      sleep error.rate_limit.reset_in + 5
    end

  end
end