require 'open-uri'
require 'nokogiri'
require 'pry'
#require_relative 'pedal.rb'
#Craigslist scrape params
    #post title: results.css("h3").text
    #Price:     results.css(".result-meta .result-price").text
class Scraper
  MAJOR_CITIES = ["washingtondc", "baltimore", "philadelphia", "atlanta", "minneapolis", "portland", "cleveland", "boston", "denver", "austin", "losangeles"]

  #redesign scraper so that it starts on https://www.craigslist.org/about/sites#US
  # which contains the country broken up by state, and each state has 5-10 regions/cities
  #and for each of these
  def self.full_scrape(pedal_type)
    html = open("https://www.craigslist.org/about/sites#US")
    full_country = Nokogiri::HTML(html)
    binding.pry
    state_links = []
    full_country.each do |area|
      state_links << area.css("a").attribute("href").text
    end
      puts state_links
  end

  def self.scrape_search(pedal_type, city = "newyork")
    html = open("https://#{city}.craigslist.org/search/msa?query=#{pedal_type}")
    doc = Nokogiri::HTML(html)
    results = doc.css(".result-row")
  # for each result, store info in a hash that pedal class uses to instantiate
  #should this work differently if user is searching based on a general category vs a specific pedal

  #need method to cycle through initial results and only keep posts that have search params in title
    pedals = []
    results.each do |r|
      if Scraper.title_check?(r.css("h3").text, pedal_type)
        pedal = {}
        pedal[:name] = r.css("h3").text.strip
        pedal[:seller_price] = r.css(".result-meta .result-price").text.strip
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
        prices << r.css(".result-meta .result-price").text.strip.split("$")[1].to_i
      end
    end
    reliable_prices = Scraper.price_range_limiter(prices)
    average_price = Scraper.price_average(reliable_prices)
    puts "Price average: $#{average_price}"
  end

  def self.price_range_limiter(price_array)
    #throws out $0-$1 posts, finds mean and median
    reliable_prices = []
    price_array.each do |price|
      #MAGIC NUMBERS BAD!!!!!
      if price > 1 && price < 300
        reliable_prices << price
      end
    end
    reliable_prices
  end

  def self.price_average(price_array)
    sum = 0
    price_array.each{|p| sum += p}
    sum / price_array.length
  end

  #method to cycle through initial results and only keep posts that have search params in title
  def self.title_check?(post_title, search_param)
    common_words = 0
    #break apart sear_param into individual words
    parameters = search_param.downcase.split
    parameters.each do |param|
    #downcase post_title and search word
      if post_title.downcase.include?(param)
        common_words += 1
      end
    end
    #return true if post_title contains at least one search param
    if common_words == parameters.length
      true
    else
      false
    end
  end
  #method to see if any posts have identical titles
  def duplicate_check?()
  end
end
Scraper.full_scrape("tubescreamer")
