#require "pbx/version"
require_relative "craigslist_scraper.rb"
require_relative "pedal.rb"
require 'pry'
# module Pbx
#   class Error < StandardError; end
#   # Your code goes here...
# end
MAJOR_CITIES = ["washingtondc", "baltimore", "philadelphia", "atlanta",
   "minneapolis", "portland", "cleveland", "boston", "denver", "austin",
    "losangeles", "chicago", "dallas", "houston", "miami", "phoenix",
    "sfbay", "detroit", "seattle", "sandiego", "tampa", "stlouis", "charlotte",
  "orlando", "sanantonio", "sacramento", "pittsburgh", "lasvegas", ""]
puts "Welcome to the PedalBoardExchange!!"
puts "What are you searching for today?"
input = gets.chomp
MAJOR_CITIES.each do |city|
  pedal_results = Scraper.scrape_search(input, city)
  Pedal.create_from_collection(pedal_results)
end
Pedal.all.each{|p| puts "#{p.name}: #{p.seller_price}"}
#Scraper.country_scrape(input)
