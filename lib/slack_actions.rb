module Slack
  module Actions

    def config
      @config
    end

#投稿( ´◔‸◔`)
    def post(text,channel="#general")
      post_slack(text,channel)
    end

#リプライ☝( ◠‿◠ )☝
    def reply(text,channel=self.channel)
      text = "<@#{self.user}> #{text}"
      post_slack(text,channel)
    end

#通知。 #439FE0 is light blue
    def notice(title,text=nil,color="#439FE0",channel="#notification")
      opt = attachments(title,text,color)
      post_slack_with_attachments(channel,{ attachments: opt.to_json })
    end

#エラー発生時
    def alert(title,text=nil,color="warning",channel="#notification")
      opt = attachments(title,text,color)
      post_slack_with_attachments(channel,{ attachments: opt.to_json })
    end

private

    def attachments(title,text,color)
      [{
        title: title,
        text: text,
        color: color,
        fallback: title
        }]
    end

    def post_slack(text,channel)
      params = {
        text: text,
        channel: channel,
        token: config["token"],
        username: config["username"],
        icon_url: config["icon_url"]
      }
      Net::HTTP.post_form(URI.parse("https://slack.com/api/chat.postMessage"),params)
    end

    def post_slack_with_attachments(channel,attachments)
      params = {
        channel: channel,
        token: config["token"],
        username: config["username"],
        icon_url: config["icon_url"]
      }
      Net::HTTP.post_form(URI.parse("https://slack.com/api/chat.postMessage"),params.merge(attachments))
    end

  end
end

module Slack
  class Message
    include Actions
    attr_accessor :args

    def initialize(conf,message)
      @config = conf
      @message = message
    end

    def type
      @message["type"] end

    def channel
      @message["channel"] end

    def user
      @message["user"] end

    def text
      @message["text"] end

    def time_stamp
      @message["ts"] end

    def team
      @message["team"] end

  end
end