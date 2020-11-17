require 'open-uri'
require 'nokogiri'
require 'pry'
class Scraper
  def self.scrape_search(pedal_type, city = "newyork")
    html = open("https://#{city}.craigslist.org/search/msa?query=#{pedal_type}")
    doc = Nokogiri::HTML(html)
    results = doc.css(".result-row")
    pedals = []
    results.each do |r|
      if title_check?(r.css("h3").text, pedal_type)
        pedal = {}
        pedal[:name] = r.css("h3").text.strip
        pedal[:seller_price] = r.css(".result-meta .result-price").text.strip
        seller_page = Nokogiri::HTML(open(r.css("a").attribute("href").text))
        pedal[:seller_description] = seller_page.css("#postingbody").text.strip
        #binding.pry
        text = seller_page.css(".attrgroup").text.strip
        boxes = text.split("\n")
        pedal[:manufacturer] = nil
        pedal[:model] = nil
        pedal[:condition] = nil
        boxes.each do |str|
          if str.include?("make / manufacturer:")
            pedal[:manufacturer] = str.split("make / manufacturer:")[1]
          elsif str.include?("model name / number:")
            pedal[:model] = str.split("model name / number:")[1]
          elsif str.include?("condition:")
            pedal[:condition] = str.split("condition:")[1]
          end
        end
      #  binding.pry
        pedals << pedal
      end
    end
    pedals
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

  def self.gc_scrape(pedal_hash)

    pedal_hash.each do |p|
        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"
      #  binding.pry
        if p[:manufacturer] != nil && p[:model] != nil
          formatted_manu_model = search_format(p[:manufacturer]+" "+p[:model])
          man_mod_url = "https://www.guitarcenter.com/search?typeAheadSuggestion=true&typeAheadRedirect=true&fromRecentHistory=false&Ntt=#{formatted_manu_model}"
          man_mod_html = open(man_mod_url, 'User-Agent' => user_agent)
          man_mod_doc = Nokogiri::HTML(man_mod_html)
          add_gc_info(man_mod_doc, p)
         else
          formatted_post_title = search_format(p[:name])
          p_t_url = "https://www.guitarcenter.com/search?typeAheadSuggestion=true&typeAheadRedirect=true&fromRecentHistory=false&Ntt=#{formatted_post_title}"
          p_t_html = open(p_t_url, 'User-Agent' => user_agent)
          p_t_doc = Nokogiri::HTML(p_t_html)
          add_gc_info(p_t_doc, p)
         end
      end
    pedal_hash
end
  def self.add_gc_info(pedal_doc, p)
    if pedal_doc.css("#searchTips").length == 0
      if pedal_doc.css(".product-container").length > 0
        pedal_doc.css(".product-container").each do |pedal|
            if !used?(pedal.css(".productTitle").text.strip) && p[:gc_name] == nil
              p[:gc_name] = pedal.css(".productTitle").text.strip
              p[:gc_price] = gc_price_parse(pedal.css(".productPrice").text)
              info_array = gc_next_level(pedal.css(".productTitle a").attribute('href').text)
              p[:gc_description] = info_array[1]
            end
          end
        else
          p[:gc_name] = pedal_doc.css(".titleWrap").text.strip
          p[:gc_price] = pedal_doc.css(".topAlignedPrice").text.strip.split("\n")[0]
          p[:gc_description] = pedal_doc.css(".description").text.strip
       end
     end
  end
  def self.gc_next_level(url_end)
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.183 Safari/537.36"
    url = "https://www.guitarcenter.com#{url_end}"
    html = open(url, 'User-Agent' => user_agent)
    doc = Nokogiri::HTML(html)
    #return an array of info to be assigned to :gc_price, :gc_description
    info = []
    info << doc.css(".topAlignedPrice").text.strip
    info << doc.css(".description").text.strip
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
