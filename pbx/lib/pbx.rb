#require "pbx/version"
require_relative "craigslist_scraper.rb"
require_relative "pedal.rb"
require 'pry'
# module Pbx
#   class Error < StandardError; end
#   # Your code goes here...
# end

#OK testing my Git capabilities
puts "Welcome to the PedalBoardExchange!!"
puts "What are you searching for today?"
input = gets.chomp
pedal_results = Scraper.scrape_search(input)
Pedal.create_from_collection(pedal_results)
Pedal.all.each{|p| puts "#{p.name}: #{p.seller_price}"}
