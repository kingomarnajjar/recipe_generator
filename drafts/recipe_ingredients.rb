require 'yummly'

Yummly.configure do |config|
  config.app_id = "8761fe27"
  config.app_key = "eb9bc332198f1609d3f41f6e426fc670"
  config.use_ssl = true # Default is false
end
system("clear")
puts "what are you in the mood for?"
search_term = gets.chomp.to_s
result = Yummly.search(search_term)
# puts result.methods
system("clear")
puts result

top_ten = []

top_ten << result.collect do |recipe|

  this_hash = {}
  this_hash[recipe.name] = recipe.ingredients

  top_ten << this_hash
end

search_result = top_ten.take(3)
puts search_result

puts "please make a selection [1], [2] or [3]"

puts search_result[gets.chomp.to_i - 1]




# top_ten_ingredients = []
#
#
# puts "this is one recipe"

#
# puts result.collect {|recipe| recipe.ingredients}

#result.collect {|recipe| recipe.ingredients}
