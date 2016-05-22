require 'open-uri'
require 'net/http'
require 'feed-normalizer'

def trend(service)
  case service
  when /Google/i
    url = "http://www.google.co.jp/trends/hottrends/atom/hourly"
  when /Yahoo/i
    url = "http://searchranking.yahoo.co.jp/rss/burst_ranking-rss.xml"
  end

  rss = FeedNormalizer::FeedNormalizer.parse(open(url))
  trend_list = []

 case service
 when /Google/i
  rss.entries.map do |item|
    trend_list = item.title
  end
  trend_list = trend_list.split(",")
 when /Yahoo/i
  rss.entries.map do |item|
    trend_list << item.title
    break if trend_list.length == 5
  end
 end

text = "#{service}トレンド:
1. #{trend_list[0]}
2. #{trend_list[1]}
3. #{trend_list[2]}
4. #{trend_list[3]}
5. #{trend_list[4]}"
  return text
end

command(/trend\s+(google|yahoo)/i) do |tweet|
  tweet.reply trend(tweet.args[0])
end