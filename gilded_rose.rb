class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      item_mapper = check(item)
      unless item_mapper == ItemsMapper::Legendary
        ItemModifier.modify(item_mapper, item)
        item.sell_in -= ItemsMapper::STEP
      end
    end
  end

  def check(item)
    if item.name == 'Sulfuras, Hand of Ragnaros'
      ItemsMapper::Legendary
    elsif item.name == 'Aged Brie'
      ItemsMapper::Cheese
    elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
      ItemsMapper::Ticket
    elsif item.name == 'Conjured Mana Cake'
      ItemsMapper::Magic
    else
      ItemsMapper::Common
    end
  end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class ItemModifier

  def self.modify(mapper, item)
    mapper.update(item)
  end

end

module ItemsMapper

  QUALITY = {
      undegradable: 0,
      highest: 50
  }

  SELL_IN = {
      zero_term: 0,
      twice_growth: 10,
      thrice_growth: 5
  }

  STEP = 1

  class Legendary
    def self.update(item)

    end
  end

  class Cheese
    def self.update(item)
      if item.quality < ItemsMapper::QUALITY[:highest]
        item.quality += ItemsMapper::STEP
        if item.sell_in <= ItemsMapper::SELL_IN[:zero_term]
          item.quality += ItemsMapper::STEP
        end
      end
    end
  end

  class Ticket
    def self.update(item)
      item.quality += ItemsMapper::STEP
      if item.sell_in <= ItemsMapper::SELL_IN[:twice_growth]
        if item.quality < ItemsMapper::QUALITY[:highest]
          item.quality += ItemsMapper::STEP
        end
      end
      if item.sell_in <= ItemsMapper::SELL_IN[:thrice_growth]
        if item.quality < ItemsMapper::QUALITY[:highest]
          item.quality += ItemsMapper::STEP
        end
      end
      if item.sell_in <= ItemsMapper::SELL_IN[:zero_term]
        item.quality = ItemsMapper::QUALITY[:undegradable]
      end
    end
  end

  class Magic
    def self.update(item)
      2.times { Common.update(item) }
    end
  end

  class Common
    def self.update(item)
      if item.quality > ItemsMapper::QUALITY[:undegradable] && item.quality < ItemsMapper::QUALITY[:highest]
        item.quality -= ItemsMapper::STEP
        if item.sell_in < ItemsMapper::SELL_IN[:zero_term]
          if item.quality > ItemsMapper::QUALITY[:undegradable]
            item.quality -= ItemsMapper::STEP
          end
        end
      end
    end
  end

end
