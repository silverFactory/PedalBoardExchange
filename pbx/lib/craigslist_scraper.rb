require 'open-uri'
require 'nokogiri'
require 'pry'
require_relative 'pedal.rb'
#Craigslist scrape params
    #post title: results.css("h3").text
    #Price:     results.css(".result-meta .result-price").text
class Scraper
  MAJOR_CITIES = ["washingtondc", "baltimore", "philadelphia", "atlanta", "minneapolis", "portland", "cleveland", "boston", "denver", "austin", "losangeles"]

  def self.scrape_search(pedal_type, city = "newyork")
    html = open("https://#{newyork}.craigslist.org/search/msa?query=#{pedal_type}")
    doc = Nokogiri::HTML(html)
    results = doc.css(".result-row")
  # for each result, stoe info in a hash that pedal class uses to instantiate
    pedals = []
    results.each do |r|
      pedal = {}
      pedal[:name] = r.css("h3").text
      pedal[:seller_price] = r.css(".result-meta .result-price").text
      pedals << pedal
    end
    pedals
  end
  def self.country_scrape(pedal_type)
    #takes in a pedal_type (same keyword as used for primary search) and finds similar posts in other major cities
    #don't need to make objects out of results, just need to get price

  end

  def self.price_comparison()
    #throws out $0-$1 posts, finds mean and median
  end

  def self.gc_scrape(pedal_name)
    html =open("https://www.ebay.com/sch/i.html?_from=R40&_trksid=p2380057.m570.l1313&_nkw=ibanez+tube+screamer&_sacat=0")
    #binding.pry
    doc = Nokogiri::HTML(html)
    results = doc.css(".product-card")
    binding.pry

    puts results
  end
end
# Scraper.scrape_search("tube+screamer")
#Scraper.gc_scrape("ibanez+tube+screamer+mini")
#puts Pedal.all[0].name
# Pedal.all.each do |p|
#   puts "#{p.name}: #{p.seller_price}"
# end
