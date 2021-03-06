class Pedal
  attr_accessor :name, :seller_description, :gc_name, :condition, :manufacturer, :model, :seller_price, :gc_price, :gc_description
  @@all = []
  def initialize(pedal_hash)
    pedal_hash.each{|k, v| self.send("#{k}=", v)}
    @@all << self
  end
  def self.create_from_collection(pedals_array)
    pedals_array.each{|p| Pedal.new(p)}
  end
  def self.all
    @@all
  end
end
