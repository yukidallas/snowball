class Twitter::Tweet
  attr_accessor :args

  def twitter
    return Snowball.rest end

  def slack
    return Snowball.slack end

  def reply(text)
    message = "@#{self.user.screen_name}\s#{text}"
    for x in $available do
      begin
        break if message =~ /^@#{screen_name}/
        twitter[x].update(message, in_reply_to_status_id: self.id)
        break
      rescue Twitter::Error::Forbidden #Over Characters
        if message.length > 140
          message = "140文字を超えたため、DMで送信しました。\n#{text}"
          twitter[x].create_direct_message(self.user.id, message)
          break
        end
      rescue Twitter::Error::TooManyRequests => e #Rate Limit
        next if x < $available.last - 1
        alert = "Rate Limit Exceeded"
        slack.alert(alert,e)
        break
      rescue Twitter::Error::ServiceUnavailable => e #バルス
        alert = "サーバー障害が発生している可能性があります。"
        slack.alert(alert,e,"danger")
        debug(e)
      rescue Exception => e
        alert = "例外を捕捉しました。"
        slack.alert(alert,e,"danger")
        debug(e)
        break
      end
    end
  end

  def post(text)
    begin
      twitter[1].update(text)
    rescue Twitter::Error::Forbidden #Over Characters
      if text.length > 140
        alert = "ツイートが140文字を超えました。"
        slack.alert(alert)
      end
    rescue Twitter::Error::TooManyRequests #Post規制
    rescue Exception => e
      alert = "例外を捕捉しました。"
      slack.alert(alert,e,"danger")
      debug(e)
    end
  end

end


$user_params = Hash.new(Array.new)

class Twitter::User
  def use(name)
    $user_params[self.id] << name end
  def using_by?(name)
    $user_params[self.id].include? name end
  def unuse(name)
    $user_params[self.id].delete name end
end