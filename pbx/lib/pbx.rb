#require "pbx/version"
require_relative "craigslist_scraper.rb"
require_relative "pedal.rb"
require 'pry'
# module Pbx
#   class Error < StandardError; end
#   # Your code goes here...
# end
# MAJOR_CITIES = ["washingtondc", "baltimore", "philadelphia", "atlanta",
#    "minneapolis", "portland", "cleveland", "boston", "denver", "austin",
#     "losangeles", "chicago", "dallas", "houston", "miami", "phoenix",
#     "sfbay", "detroit", "seattle", "sandiego", "tampa", "stlouis", "charlotte",
#   "orlando", "sanantonio", "sacramento", "pittsburgh", "lasvegas", ""]
puts "Welcome to the PedalBoardExchange!!"
puts "What are you searching for today?"
input = gets.chomp
# MAJOR_CITIES.each do |city|
#   pedal_results = Scraper.scrape_search(input, city)
#   Pedal.create_from_collection(pedal_results)
# end
pedal_results = Scraper.scrape_search(input)
#for each pedal posting on CL, i want to scrape GC for the new price and description
pedals_with_extras = Scraper.gc_scrape(pedal_results, input)
Pedal.create_from_collection(pedals_with_extras)
Pedal.all.each_with_index{|p, i| puts "#{i+1}- #{p.name}: listed for #{p.seller_price}"}
puts "For more information about a pedal, please enter corresponding number:"
desc_choice = gets.chomp.to_i
puts Pedal.all[desc_choice-1].name
puts "What would you like to know?"
puts "1 - Seller Description"
puts "2 - Price New as Listed on Guitar Center"
puts "3 - Manufacturer Description"
puts "4 - Back to Craigslist Search Results"
sub_menu_choice = gets.chomp.to_i
if sub_menu_choice == 1
  puts Pedal.all[desc_choice-1].seller_description
elsif sub_menu_choice == 2
  puts Pedal.all[desc_choice-1].gc_price
elsif sub_menu_choice == 3
  puts Pedal.all[desc_choice-1].gc_description
elsif sub_menu_choice == 4
  #recursive call
else
  puts "Please enter a valid choice..."
end
