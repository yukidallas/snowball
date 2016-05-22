command(/おるか(\?|？)?/) do |tweet|
  tweet.reply "∩(・＿・)∩おるでｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗｗ"
end

on_streaming do |tweet|
  next if tweet.text !~ /(課題|宿題)/
  next if tweet.text =~ /rt|@/i
  obj.reply "進捗どうですか？"
end

on_streaming do |tweet|
  next if tweet.text !~ /(334|３３４|33(-|ー)4)/i
  tweet.reply "なんでや！阪神関係ないやろ！"
end

command "chaken" do |tweet|
  phrase = YAML.load_file('./config/chaken.yml')
  tweet.reply "#{phrase.sample}"
end

on_streaming do |tweet|
  next if tweet.text !~ /(天神|てんじん|テンジン)/
  tweet.reply "天↑神↓は、教↑科↑書↓とリンクした、学習シィステム！"
end