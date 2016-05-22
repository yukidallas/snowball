command(/follow\s?(me|back)|フォロバ/) do |obj|
  Snowball.rest.each do |id,account|
    account.follow obj.user
  end
end