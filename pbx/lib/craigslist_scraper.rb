require 'open-uri'
require 'nokogiri'
require 'pry'
require_relative 'pedal.rb'
#Craigslist scrape params
    #post title: results.css("h3").text
    #Price:     results.css(".result-meta .result-price").text
class Scraper

  def self.scrape_search(pedal_type)
    html = open("https://newyork.craigslist.org/search/msa?query=#{pedal_type}")
    doc = Nokogiri::HTML(html)
    results = doc.css(".result-row")
    #puts results.length
    results.each do |r|
      pedal = Pedal.new
      pedal.name = r.css("h3").text
      pedal.seller_price = r.css(".result-meta .result-price").text
    end
    # for each result, make a new pedal object with name and price
  end

  def self.gc_scrape(pedal_name)
    html =open("https://www.guitarcenter.com/Ibanez/TS9-Tube-Screamer-Effects-Pedal-1274115043047.gc")
    binding.pry
    doc = Nokogiri::HTML(html)
    results = doc.css(".product")
    puts doc
  end
end
# Scraper.scrape_search("tube+screamer")
Scraper.gc_scrape("ibanez+tube+screamer+mini")
#puts Pedal.all[0].name
# Pedal.all.each do |p|
#   puts "#{p.name}: #{p.seller_price}"
# end
