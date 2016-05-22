module Snowball
  module Streaming

    def extract_timeline(obj)
      ActiveRecord::Base.connection_pool.with_connection do
        case obj
        when Twitter::Tweet
          next if obj.retweet?
          next if @archives.include? obj.id
          store_tweet(obj)

          streaming_events.each do |proc|
            proc.call obj
          end

          command_callback obj
          next if @posted.include? obj.id
          registered_command_callback obj
          next if @posted.include? obj.id
          protected_command_callback obj
          next if @posted.include? obj.id
          talk obj
        when Twitter::Streaming::Event
          case obj.name
          when :follow
            followed_event(obj)
          end
        when Twitter::Streaming::FriendList
          #Get follower list when connect streaming.
        when Twitter::Streaming::StallWarning
          slack.alert("#{Stall Warning!}")
        end
      end
    end

private

    def store_tweet(tweet)
      @archives << tweet.id
      @archives.shift if @archives.length > 100
    end

    def store_reply(tweet)
      @posted << tweet.id
      @posted.shift if @posted.length > 100
    end

    def streaming_events
      @streaming_events end
    def commands
      @commands end
    def registered_commands
      @registered_commands end
    def protected_commands
      @protected_commands end

    def command_callback status
      commands.each do |cmd, procs|
        next unless status.text =~ /^(?!RT)@#{screen_name}\s+#{cmd}/i
        status.args = [$1,$2,$3,$4,$5]
        store_reply(status)

        procs.each {|proc|proc.call status}
      end
    end

    def registered_command_callback status
      if user_params = User.find_by(twitter_id: status.user.id)
        registered_commands.each do |cmd, procs|
          next unless status.text =~ /^(?!RT)@#{screen_name}\s+#{cmd}/i
          status.args = [$1,$2,$3,$4,$5]
          store_reply(status)

          procs.each {|proc|proc.call status,user_params}
        end
      end
    end

    def protected_command_callback status
      if status.user.screen_name == "yukidallas"
        protected_commands.each do |cmd, procs|
          next unless status.text =~ /^(?!RT)@#{screen_name}\s+admin\s+#{cmd}/i
          status.args = [$1,$2,$3,$4,$5]
          store_reply(status)

          procs.each {|proc|proc.call status}
        end
      end
    end

    def followed_event(obj)
      if obj.source.screen_name != screen_name
        message = "#{obj.source.name} (@#{obj.source.screen_name})さんにフォローされました。"
        slack.notice(message)
      end
    end

  end
end