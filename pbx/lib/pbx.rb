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
Pedal.all.each{|p| puts "#{p.name}: listed for#{p.seller_price}, new price: #{p.gc_price}, pedal description #{p.gc_description}"}
#Scraper.country_scrape(input)
