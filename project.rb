require 'HTTParty'
require 'Nokogiri'
require "csv"
require 'gruff'
require 'catpix'

class Recipe
  def initialize(url)
    @url = url
  end

  def get_recipe_name
    page = HTTParty.get(@url)
    parse_page = Nokogiri::HTML(page)
    title = parse_page.css("h1")
    title_of_recipe = title.text
  end

  def get_recipe_ingredient_list

    page = HTTParty.get(@url)
    parse_page = Nokogiri::HTML(page)
    @scraped_ingredient = []
    ingredient_list = []

    parse_page.css(".ingredient-description").each do |a|
      ing = a.text.downcase
      @scraped_ingredient << ing
    end
    @scraped_ingredient
  end

  def get_amounts_per_ingredient
    @quantity = []

    @scraped_ingredient.each do |intsearch|
      a = intsearch.slice(0, 4).gsub(/[^0-9]/, '')
      if intsearch.include?("teaspoon")
        a = a.to_i * 5
        @quantity << a
      elsif intsearch.include?("tablespoon")
        a = a.to_i * 15
        @quantity << a
      elsif intsearch.include?("g")
        a = a.to_i
        @quantity << a
      elsif intsearch.include?("ml")
        a = a.to_i
        @quantity << a
      else
        a = a.to_i * 50
        @quantity << a
      end

    end
    @quantity
  end



end

class EnvironmentImpact

  def initialize(ingredient_list)
    @ingredient_list = ingredient_list
    @totallist = []
    @totalcarbon = []
  end

  def get_amounts_per_ingredient
    @quantity = []

    @scraped_ingredient.each do |intsearch|
      a = intsearch.slice(0, 4).gsub(/[^0-9]/, '')
      if intsearch.include?("teaspoon")
        a = a.to_i * 5
        @quantity << a
      elsif intsearch.include?("tablespoon")
        a = a.to_i * 15
        @quantity << a
      elsif intsearch.include?("g")
        a = a.to_i
        @quantity << a
      elsif intsearch.include?("ml")
        a = a.to_i
        @quantity << a
      else
        a = a.to_i * 50
        @quantity << a
      end

    end
    @quantity
  end

  def carbon_intensity
    carbonarray = []

    CSV.foreach("carbonfootprint.csv") do |row|
      carbonarray << row
    end

    namelist = []
    carbonarray.each do |csv_ingredient|
      @ingredient_list.each do |recipe_item|
        # csv_ingredient[0] returns name
        # puts csv_ingredient[0].to_s
        # check if provided recipe line includes a csv ingredient name
        if recipe_item.downcase.include?(csv_ingredient[0].downcase)
          a = recipe_item.slice(0, 5).gsub(/[^0-9]/, '')
          if recipe_item.include?("teaspoon")
            a = a.to_i * 5
          elsif recipe_item.include?("tablespoon")
            a = a.to_i * 15
          elsif recipe_item.slice(0,7).include?("g ")
            a = a.to_i
          elsif recipe_item.include?("ml")
            a = a.to_i
          else
            a = a.to_i * 50
          end
          a.to_i
          #puts "#{a}g of #{csv_ingredient[0]} adds #{csv_ingredient[1].to_f * a} CO2"
          b = csv_ingredient[1].to_f * a
          @totalcarbon << b.to_f
        else
          #puts "false"
        end
      end
    end
    @totalcarbon
  end

  def carbon_intensity_per_gram
    carbonarray = []

    CSV.foreach("carbonfootprint.csv") do |row|
      carbonarray << row
    end

    namelist = []
    carbonarray.each do |csv_ingredient|
      @ingredient_list.each do |recipe_item|
        # csv_ingredient[0] returns name
        # puts csv_ingredient[0].to_s
        # check if provided recipe line includes a csv ingredient name
        if recipe_item.downcase.include?(csv_ingredient[0].downcase)
          puts "Each gram of #{csv_ingredient[0]} adds #{csv_ingredient[1]} CO2"
          @totallist << csv_ingredient[1].to_f
          namelist << csv_ingredient[0]
        else
          #puts "false"
        end
      end
    end
    puts @totallist
  end

  def recipeimpact
    sum = 0
    @totalcarbon.each { |a| sum+=a }
    sum.round(3)
    #puts "This recipe puts out #{sum}g of CO2"
  end

  def top5impact
    sum = 0
    @totallist.sort.reverse.take(5).each { |a| sum+=a }
    sum.round(3)
  end

  def image
    carbon = a.recipeimpact
    case carbon
    when 0
      puts "no carbon"
    when 1..2000
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
    when 2000..4000
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
    when 4000..6000
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

    when 6000..8000
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
    when 8000..10000
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

end

class Graph
  def initialize(carbonnumber, x, y, z)
    carbonnumber = @carbonnumber
    x = @x
    y = @y
    z = @z
    arg = 0
  end

  attr_accessor :carbonnumber, :x, :y, :z

  def image(arg)
    @carbonnumber = arg
    case @carbonnumber
    when 0
      puts "no carbon"
    when 1..2000
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
    when 2000..4000
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
    when 4000..6000
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

    when 6000..8000
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
    when 8000..100000
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

def bargraph(x, y, z)
  @datasets = [:Recipe1, 2], [:Recipe2, 2], [:Recipe3, 2]
  puts @datasets[0]
  g = Gruff::Bar.new
  g.title = 'Visual Multi-Line Bar Graph Test'
  @datasets.each do |data|
      g.data(data[0], data[1])
    end

    g.write('bar_keynote_small.png')
end

end

puts "Which recipes would you like to compare for their carbon footprint? (please put in URL from taste.com.au)"

puts "Recipe 1:"
recipe1 = Recipe.new(gets.chomp)
puts "Recipe 2:"
recipe2 = Recipe.new(gets.chomp)
puts "Recipe 3:"
recipe3 = Recipe.new(gets.chomp)

# puts out titles
# puts "You have selected:"
# puts recipe1.get_recipe_name
# puts recipe2.get_recipe_name
# puts recipe3.get_recipe_name


#puts recipe1.get_recipe_ingredient_list

#carbon carbon_intensity_per_gram


a = EnvironmentImpact.new(recipe1.get_recipe_ingredient_list)
b = EnvironmentImpact.new(recipe2.get_recipe_ingredient_list)
c = EnvironmentImpact.new(recipe3.get_recipe_ingredient_list)

#
# a.carbon_intensity_per_gram
# puts a.top5impact

#puts recipe1.get_recipe_ingredient_list
#amounts = recipe1.get_amounts_per_ingredient

# a.recipeimpact
#
# # puts recipe1.get_amounts_per_ingredient
a.carbon_intensity
b.carbon_intensity
c.carbon_intensity
# puts recipe1.get_amounts_per_ingredient.class
# puts a.recipeimpact
#amounts.zip(a.carbon_intensity_per_gram).map{|x, y| x * y}
# a.carbon_intensity_per_gram

puts "#{recipe1.get_recipe_name} emits #{a.recipeimpact} g of CO2"
puts "#{recipe2.get_recipe_name} emits #{b.recipeimpact} g of CO2"
puts "#{recipe3.get_recipe_name} emits #{c.recipeimpact} g of CO2"

# puts a.recipeimpact
puts "Select [1], [2] or [3]"
choice = gets.chomp

graph1 = Graph.new(0, a.recipeimpact, b.recipeimpact, c.recipeimpact)
# graph1.bargraph(x, y, z)

if choice == "1"
  puts graph1.image(a.recipeimpact)
elsif choice == "2"
  puts graph1.image(b.recipeimpact)
elsif choice == "3"
  puts graph1.image(c.recipeimpact)
else
  puts "Error"
end
