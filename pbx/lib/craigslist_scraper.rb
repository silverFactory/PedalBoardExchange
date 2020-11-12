require 'open-uri'
require 'nokogiri'
require 'pry'

#Craigslist scrape params
    #post title: results.css("h3").text
    #Price:     results.css(".result-meta .result-price").text
class Scraper

  def self.scrape_search(pedal_type)
    html = open("https://newyork.craigslist.org/search/msa?query=#{pedal_type}")
    doc = Nokogiri::HTML(html)
    results = doc.css(".result-info")
    results.css(".result-meta")

    # results.each do |r|
    #   puts r.css("a")
    # end
  end

end
puts Scraper.scrape_search("tube+screamer")
