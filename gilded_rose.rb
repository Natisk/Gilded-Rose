class GildedRose
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

  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      item_type = map_item(item)
      unless item_type == :legendary
        if item_type == :cheese
          if item.quality < QUALITY[:highest]
            item.quality += STEP
            if item.sell_in <= SELL_IN[:zero_term]
              item.quality += STEP
            end
          end
        elsif item_type == :ticket
          item.quality += STEP
          if item.sell_in <= SELL_IN[:twice_growth]
            if item.quality < QUALITY[:highest]
              item.quality += STEP
            end
          end
          if item.sell_in <= SELL_IN[:thrice_growth]
            if item.quality < QUALITY[:highest]
              item.quality += STEP
            end
          end
          if item.sell_in <= SELL_IN[:zero_term]
            item.quality = QUALITY[:undegradable]
          end
        elsif item.quality > QUALITY[:undegradable] && item.quality < QUALITY[:highest]
          decrease_amount = item_type == :magic ? STEP*2 : STEP
          item.quality -= decrease_amount
          if item.sell_in < SELL_IN[:zero_term]
            if item.quality > QUALITY[:undegradable]
              item.quality -= decrease_amount
            end
          end
        end

        item.sell_in -= STEP
      end
    end
  end

  def map_item(item)
    if item.name == 'Sulfuras, Hand of Ragnaros'
      :legendary
    elsif item.name == 'Aged Brie'
      :cheese
    elsif item.name == 'Backstage passes to a TAFKAL80ETC concert'
      :ticket
    elsif item.name == 'Conjured'
      :magic
    else
      :common_item
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
