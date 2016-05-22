require 'time'

def timer(arg, &blk)
  x = case arg
  when Numeric then arg
  when Time    then arg - Time.now
  when String  then Time.parse(arg) - Time.now
  else raise   end

  Thread.start do
    sleep x if block_given?
    blk.call
  end
end

command(/timer\s+([0-9]+:[0-9]+)/) do |obj|
  if obj.user.using_by?(:timer)
    obj.reply "アラームは１つのみ設定可能です。"
  else
    obj.user.use(:timer)
    obj.reply "#{obj.args[0]} にアラームを設定しました。"
    timer(obj.args[0]) do
      obj.reply "Ring Ring! (#{obj.args[0]})"
      obj.user.unuse(:timer)
    end
  end
end