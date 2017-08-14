require 'yummly'
#require 'gruff'
require "csv"
require 'catpix'

Yummly.configure do |config|
  config.app_id = "8761fe27"
  config.app_key = "eb9bc332198f1609d3f41f6e426fc670"
  config.use_ssl = true # Default is false
end
system("clear")
puts "Welcome to the recipe factory"
puts "What are you in the mood for?"

search_term = gets.chomp.to_s

puts "  Excellent! You chose:"
puts "    #{search_term}"
puts "      Good choice"
puts "give me a second"
puts "..."
sleep(1)

search_term
result = Yummly.search(search_term)
# puts result.methods
system("clear")

# MIGHT NEED TO BRING BACK
# puts result

top_ten = []
@inglist =[]
@recilist = []

top_ten << result.collect do |recipe|

  this_hash = {}
  this_hash[recipe.name] = recipe.ingredients
  @recilist << recipe.name
  @inglist << recipe.ingredients
  top_ten << this_hash
end

search_result = top_ten.take(3)

=begin

# puts search_result[gets.chomp.to_i - 1]

# top_ten_ingredients = []
#
#
# puts "this is one recipe"

#
# puts result.collect {|recipe| recipe.ingredients}

#result.collect {|recipe| recipe.ingredients}

# part 2
#
# require 'HTTParty'
# require 'Nokogiri'
#
#
# # creating classes
# class Url
#   def initialize(url)
#     @url = url
#   end
#
#   attr_accessor :url
#
#   def self.all
#     ObjectSpace.each_object(self).to_a
#   end
# end
#
# url1 = Url.new("http://www.taste.com.au/recipes/chicken-bstilla-pies/uGbryXOY?r=quickeasy/kj1r4Zny")
# url2 = Url.new("http://www.taste.com.au/recipes/beef-olive-spaghetti-bolognese/77f0654c-0c53-4f95-bc41-d864ae90426d?r=recipes/beefrecipes&c=ed77f9a0-ff56-40d0-b903-b24e86c38152/Beef%20recipes")
# url3 = Url.new("http://www.taste.com.au/recipes/pappardelle-pumpkin-bacon-torn-bread/2318e227-1dc9-463f-94ee-e4c0ddf0778f?r=recipes/pastarecipes&c=9a361b5c-6b07-48cb-ba64-399b8627268c/Pasta%20recipes")
#
# # # scraping title
# def get_recipe_title(url)
#   page = HTTParty.get(url)
#   parse_page = Nokogiri::HTML(page)
#   title = parse_page.css("h1")
#   title_of_recipe = title.text
# end
#
# # scraping ingredients
# def get_recipe_ingredient_list(url)
#
#   page = HTTParty.get(url)
#   parse_page = Nokogiri::HTML(page)
#   @scraped_ingredient = []
#   ingredient_list = []
#
#   parse_page.css(".ingredient-description").each do |a|
#     ing = a.text.downcase
#     @scraped_ingredient << ing
#   end
#

recipe_list = []
#
# Url.all.each do |i|
#   recipe_list << i.url
# end
=end

#UNMASK THESE ONES


@carbonarray = []

CSV.foreach("carbonfootprint.csv") do |row|
  @carbonarray << row
end

just_ingredients = []

@carbonarray.each do |ingredient_line|
  just_ingredients << ingredient_line[0].downcase
end

# this is the input from Jon

# total = 0
# carbonarray.each do |csv_ingredient|
#   recipe.each do |recipe_item|
#     # csv_ingredient[0] returns name
#     # puts csv_ingredient[0].to_s
#     # check if provided recipe line includes a csv ingredient name
#     if recipe_item.include?(csv_ingredient[0].downcase)
#       #puts "item #{csv_ingredient[0]} carbon value: #{csv_ingredient[1]}"
#       total = total + csv_ingredient[1].to_i
#     else
#       #puts "false"
#     end
#   end
# end

#puts total
carbon = 0
def image
  case @carbon
  when 0
    puts "no carbon"
  when 1..20
      puts "carbon low"
      puts "

              `*******'
                .---.
               ( --- )
              ( /m m\ )
            ___(  =  )___
          .'----`\ /'----`.
         //' .-'': ;``-. `\\
        //  /     Y     \  \\
       //  /     (|)     \  \\
      //  :   .-' | `-.   ;  \\
     //    `.__.-'^`-.__.'    \\
     ^. .^.^/           \^.^. .^
       ^   / CARBON LOW  \   ^
          /               \
        _.'                 `._
      '._                   _.'
         `--..___   ___..--'
                 ```


    "
  when 20..40
      puts "carbon moderately low"
      puts   "
      __   /   \   __
     (  `'.\   /.'`  )
      '-._.(;;;)._.-'
      .-'  ,``,  '-. CARBON MODERATELY LOW
     (__.-'/   \'-.__)/)_
           \   /\    / / )
            '-'  |   \/.-')
            ,    | .'/\'..)
            |\   |/  | \_)
            \ |  |   \_/
             | \ /
              \|/    _,
              /  __/ /
              | _/ _.'
              |/__/
               \
          "
  when 40..60
      puts "carbon medium"
      puts  "


                                \     (      /
                           `.    \     )    /    .'
                             `.   \   (    /   .'
                               `.  .-''''-.  .'
          CARBON MEDIUM! `~._    .'/_    _\`.    _.~'
                             `~ /  / \  / \  \ ~'
                        _ _ _ _|  _\O/  \O/_  |_ _ _ _
                               | (_)  /\  (_) |
                            _.~ \  \      /  / ~._
                         .~'     `. `.__.' .'     `~.
                               .'  `-,,,,-'  `.
                             .'   /    )   \   `.
                           .'    /    (     \    `.
                                /      )     \

        "

  when 60..80
      puts "carbon moderately high"
      puts "
  ____________________
  /                    \
  !CARBON MODERATELY HIGH!
  !                     !
  \____________________/
           !  !
           !  !
           L_ !
          / _)!
         / /__L
   _____/ (____)
          (____)
   _____  (____)
        \_(____)
           !  !
           !  !
           \__/
      ""
      ""
      "
  when 80..100
      puts "carbon high"
      puts "
              _,.-------.,_
          ,;~'             '~;,
          ,;                     ;,
          ;      CARBON HIGH!!!    ;
          ,'                         ',
          ,;                           ;,
          ; ;      .           .      ; ;
          | ;   ______       ______   ; |
          |  `/~o     ~o . o~     o~\'  |
          |  ~  ,-~~~^~, | ,~^~~~-,  ~  |
          |   |        }:{        |   |
          |   l       / | \       !   |
          .~  (__,.--/ .^. \--.,__)  ~.
          |     ---;' / | \ `;---     |
          \__.       \/^\/       .__/
          V| \                 / |V
          | |T~\___!___!___/~T| |
          | |`IIII_I_I_I_IIII'| |
          |  \,III I I I III,/  |
          \   `~~~~~~~~~~'    /
          \   .       .   /
          \.    ^    ./
          ^~~~^~~~^
          "
  else
    puts "error."
  end
end


#as above, put top 5 values
@piearray = []

def carboncalc(recipe)
  totallist = []
  @carbonarray.each do |csv_ingredient|
    recipe.each do |recipe_item|
      # csv_ingredient[0] returns name
      # puts csv_ingredient[0].to_s
      # check if provided recipe line includes a csv ingredient name
      if recipe_item.include?(csv_ingredient[0].downcase)
        # puts "item #{csv_ingredient[0]} carbon value: #{csv_ingredient[1]}"
        totallist << csv_ingredient[1].to_i
      else
        #puts "false"
      end
    end
  end

  sum = 0
  totallist.sort.reverse.take(5).each { |a| sum+=a }
  #puts sum.to_i
  # puts totallist
  # totallist[0..4].each { |a| sum+=a }
  #puts sum
  @piearray << sum
end

#user sel

puts "Here are three recipes we have selected for you"
puts
puts "[1] #{@recilist[0]}....#{carboncalc(@inglist[0])}"
puts "[2] #{@recilist[1]}....#{carboncalc(@inglist[1])}"
puts "[3] #{@recilist[2]}....#{carboncalc(@inglist[2])}"
puts
puts
puts "We've rated the carbon footprint of each recipe for"
puts "you so as to better inform your decision. The lower"
puts "the number, the better it is for the environment."
puts
puts "When you're ready please select you choice"
puts "          [1], [2] or [3]"

puts @piearray

Catpix::print_image "pie_keynote.png",
  :limit_x => 1.0,
  :limit_y => 0,
  :center_x => true,
  :center_y => true,
  :bg => "white",
  :bg_fill => true,
  :resolution => "high"

  @datasets = [
    [@recilist[0], [@piearray[0]]],
    [@recilist[1], [@piearray[1]]],
    [@recilist[2], [@piearray[2]]]
  ]

  g = Gruff::Pie.new
  g.title = "Visual Pie Graph Test"
  @datasets.each do |data|
    g.data(data[0], data[1])
  end

  # Default theme
  g.write("pie_keynote.png")

runner = 1

while runner == 1
selection = gets.chomp.to_i

  if selection == 1
    @carbon = (carboncalc(@inglist[0]) *3)
    image
    runner = 0
  elsif selection == 2
    @carbon = (carboncalc(@inglist[1]) *3)
    image
    runner = 0
  elsif selection == 3
    @carbon = (carboncalc(@inglist[2]) *3)
    image
    runner = 0
  else
    puts "please make valid selection [1], [2] or [3]"
    runner = 1
  end
end
