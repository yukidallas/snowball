module Snowball

  module_function
  def rest(client={})
    @rest ||= client end
  def slack(client={})
    @slack ||= client end

  module Client

    def rest_client
      return @rest_client unless @rest_client.nil?
      @rest_client = {}

      config[:twitter].each do |id, key|
        rest_client[id] = Twitter::REST::Client.new key
        break unless use_multi_client?
      end
      $available = 1..rest_client.length
      return rest_client
    end

    def streaming_client
      @streaming_client ||= Twitter::Streaming::Client.new(config[:twitter][1])
    end

    def slack_client
      @slack_client ||= Slack::Notifier.new(config[:slack])
    end

  end
end

def screen_name
  /snowhiteball*/ end

def slack_id
  "U0W5DD9SL" end