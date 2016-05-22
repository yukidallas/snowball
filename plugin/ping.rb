command "ping" do |tweet|
  t = Time.at(((tweet.id >> 22) + 1288834974657) / 1000.0)
  tweet.reply "Pong!\s(#{Time.now - t}s)"
end

slack_command(/ping/i) do |obj|
  obj.reply "pong!"
end