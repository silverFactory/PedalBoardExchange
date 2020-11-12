class Pedal
  attr_accessor :name, :manufacturer, :model, :seller_price, :gc_price, :gc_description, :gc_used, :Ebay_buy_now, :for_trade
  @@all = []
  def initialize(name= nil, price = nil)
    @name = name
    @price = price
    @@all << self
  end
  def self.all
    @@all
  end
end
