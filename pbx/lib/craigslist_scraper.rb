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
      #CHANGE UPPER LIMIT TO NEW PRICE FROM GC
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

  #GC_name: .css(".productTitle")[0].text.strip
  #link_to_product_page(needs concat with gc.com...): .css(".productTitle a")[0].attribute('href').text
  #GC_price_new: .css(".topAlignedPrice").text
  #manufacturer_description: .css(".description").text

  #NEXT STEP CHAIN USER SEARCH, THROUGH CRAIGSLIST TO GC
  #uses a pedal object to search GC for more info
  #should be one method to scrape gc and a separate to add data to pedal object
  #should take in a pedal hash, and add info to each pedal, THEN the hash goes thru creat_by_collection
  def self.gc_scrape(pedal_hash, user_input)

    pedal_hash.each do |p|
        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"
        formatted_user_search = search_format(user_input)
        formatted_post_title = search_format(p[:name])
        #go thru p_t results and skip any that have used in title
        #if you can get a result using the post title, get that info
        #else try with user_input
        p_t_url = "https://www.guitarcenter.com/search?typeAheadSuggestion=true&typeAheadRedirect=true&fromRecentHistory=false&Ntt=i#{formatted_post_title}"
        p_t_html = open(p_t_url, 'User-Agent' => user_agent)
        p_t_doc = Nokogiri::HTML(p_t_html)
        u_s_url = "https://www.guitarcenter.com/search?typeAheadSuggestion=true&typeAheadRedirect=true&fromRecentHistory=false&Ntt=i#{formatted_user_search}"
        u_s_html = open(u_s_url, 'User-Agent' => user_agent)
        u_s_doc = Nokogiri::HTML(u_s_html)
        #binding.pry
        #if the post_title gets gc results
      #  if p_t_doc.css(".productTitle")[0] != nil
            #if the first one is used? == false
          #  binding.pry
            # if !Scraper.used?(p_t_doc.css(".productTitle")[0].text.strip)
            #   p[:gc_name] = p_t_doc.css(".productTitle")[0].text.strip
            #   info_array = Scraper.gc_next_level(p_t_doc.css(".productTitle a")[0].attribute('href').text)
            # #  p[:gc_price] = info_array[0]
            #   #binding.pry
            #   p[:gc_price] = Scraper.gc_price_parse(p_t_doc.css(".productPrice")[0].text)
            #   p[:gc_description] = info_array[1]
            # else #find one that aint used
            #binding.pry
            if p_t_doc.css("#searchTips").length == 0
              if p_t_doc.css(".product-container").length > 0
                p_t_doc.css(".product-container").each do |pedal|
                #  binding.pry
                    if !Scraper.used?(pedal.css(".productTitle").text.strip) && p[:gc_name] == nil
                      p[:gc_name] = pedal.css(".productTitle").text.strip
                      p[:gc_price] = Scraper.gc_price_parse(pedal.css(".productPrice").text)
                      #binding.pry
                      info_array = Scraper.gc_next_level(pedal.css(".productTitle a").attribute('href').text)
                      p[:gc_description] = info_array[1]
                    end
                  end
                else
                  #binding.pry
                  p[:gc_name] = p_t_doc.css(".titleWrap").text.strip
                  p[:gc_price] = p_t_doc.css(".topAlignedPrice").text.strip
                  p[:gc_description] = p_t_doc.css(".description").text.strip
               end
             end
      end
    pedal_hash
end #method end
  def self.gc_next_level(url_end)
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"
    url = "https://www.guitarcenter.com#{url_end}"
    html = open(url, 'User-Agent' => user_agent)
    doc = Nokogiri::HTML(html)
    #return an array of :gc_price, gc_description
    info = []
    info << doc.css(".topAlignedPrice").text.strip
    info << doc.css(".description").text.strip
    #binding.pry
    info
  end
  def self.gc_price_parse (price)
    price.split("Your Price")[1]
  end
  def self.search_format(pedal_name)
    #break apart pedal_name, then concat with + between each word
    name_pieces = pedal_name.split
    name_pieces.join("+")
  end
  def self.used?(gc_title)
    gc_title.downcase.split.include?("used")
  end
end
#Scraper.full_scrape("tubescreamer")
#Scraper.gc_scrape("Ibanez tube screamer")
#Scraper.gc_next_level
