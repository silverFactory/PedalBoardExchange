#require "pbx/version"
# require_relative "craigslist_scraper.rb"
# require_relative "pedal.rb"
require 'pry'
# module Pbx
#   class Error < StandardError; end
#   # Your code goes here...
# end
class PBX
  def start_up
    puts "Welcome to the New York PedalBoardExchange!!"
    puts "What are you searching for today?"
    pedal = gets.chomp
    puts "This may take a moment..."
    pedal_results = Scraper.scrape_search(pedal)
    pedals_with_extras = Scraper.gc_scrape(pedal_results, pedal)
    Pedal.create_from_collection(pedals_with_extras)
    if Pedal.all.length > 0
      PBX.listings
    else
      puts "No luck today, sorry!"
    end
  end

  def self.listings
    Pedal.all.each_with_index{|p, i| puts "#{i+1}- #{p.name}: listed for #{p.seller_price}"}
    puts "For more information about a pedal, please enter corresponding number:"
    ped_choice = gets.chomp.to_i
    PBX.menu(ped_choice)
  end
  def self.menu(ped_choice)
    puts Pedal.all[ped_choice-1].name
    puts "What would you like to know?"
    puts "1 - Seller Description"
    puts "2 - Price New as Listed on Guitar Center"
    puts "3 - Manufacturer Description"
    puts "4 - Back to Craigslist Search Results"
    sub_menu_choice = gets.chomp.to_i
    PBX.sub_menu(sub_menu_choice, ped_choice)
  end

  def self.sub_menu(s_m_c, p_c)
    if s_m_c == 1
      puts Pedal.all[p_c-1].seller_description
      PBX.end_menu(s_m_c, p_c)
    elsif s_m_c == 2
      puts Pedal.all[p_c-1].gc_price
      PBX.end_menu(s_m_c, p_c)
    elsif s_m_c == 3
      puts Pedal.all[p_c-1].gc_description
      PBX.end_menu(s_m_c, p_c)
    elsif s_m_c == 4
      self.listings
    else
      puts "Please enter a valid choice..."
    end
  end
  def self.end_menu(s_m_c, p_c)
    puts "\nWhat would you like to do next?"
    puts "1 - Back to info about this pedal"
    puts "2 - Back to list of all pedals"
    puts "3 - Exit program"
    end_menu = gets.chomp.to_i
    if end_menu == 1
      PBX.menu(p_c)
    elsif end_menu == 2
      PBX.listings
    elsif end_menu == 3
      puts "Thanks for visiting PBX"
    end
  end
end
