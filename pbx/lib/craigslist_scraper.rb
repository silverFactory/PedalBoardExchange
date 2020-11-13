require 'open-uri'
require 'nokogiri'
require 'pry'
#require_relative 'pedal.rb'
#Craigslist scrape params
    #post title: results.css("h3").text
    #Price:     results.css(".result-meta .result-price").text
class Scraper
  MAJOR_CITIES = ["washingtondc", "baltimore", "philadelphia", "atlanta", "minneapolis", "portland", "cleveland", "boston", "denver", "austin", "losangeles"]

  def self.scrape_search(pedal_type, city = "newyork")
    html = open("https://#{city}.craigslist.org/search/msa?query=#{pedal_type}")
    doc = Nokogiri::HTML(html)
    results = doc.css(".result-row")
  # for each result, store info in a hash that pedal class uses to instantiate
  #should this work differently if user is searching based on a general category vs a specific pedal

  #need method to cycle through initial results and only keep posts that have search params in title
    pedals = []
    results.each do |r|
      if title_check?(r.css("h3").text, pedal_type)
        pedal = {}
        pedal[:name] = r.css("h3").text
        pedal[:seller_price] = r.css(".result-meta .result-price").text
        pedals << pedal
      end
    end
    pedals
  end
  def self.country_scrape(pedal_type)
    #takes in a pedal_type (same keyword as used for primary search) and finds similar posts in other major cities
    #returns an array of prices
    prices = []
    MAJOR_CITIES.each do |city|
      html = open("https://#{city}.craigslist.org/search/msa?query=#{pedal_type}")
      doc = Nokogiri::HTML(html)
      results = doc.css(".result-row")
        #method to cycle through initial results and only keep posts that have search params in title
      results.each do |r|
        prices << r.css(".result-meta .result-price").text
      end
    end
    prices
  end

  def self.price_comparison(price_array)
    #throws out $0-$1 posts, finds mean and median
  end

  #method to cycle through initial results and only keep posts that have search params in title
  def title_check?(post_title, search_param)
    common_words = 0
    #break apart sear_param into individual words
    search_param.downcase.split.each do |param|
    #downcase post_title and search word
      if post_title.downcase.include?(param)
        common_words += 1
      end
    end
    #return true if post_title contains at least one search param
    if common_words >=1
      true
    else
      false
    end
  end


end
# Scraper.scrape_search("tube+screamer")
#Scraper.gc_scrape("ibanez+tube+screamer+mini")
#puts Pedal.all[0].name
# Pedal.all.each do |p|
#   puts "#{p.name}: #{p.seller_price}"
# end
