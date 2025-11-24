# frozen_string_literal: true

module QualityMethods
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def increase_quality(amount = 1)
    @item.quality = [@item.quality + amount, MAX_QUALITY].min
  end

  def decrease_quality(amount = 1)
    @item.quality = [@item.quality - amount, MIN_QUALITY].max
  end

  def decrease_sell_in
    @item.sell_in -= 1
  end
end

module NormalBehavior
  include QualityMethods

  def update
    decrease_quality(1)
    decrease_sell_in
    decrease_quality(1) if @item.sell_in.negative?
  end
end

module AgedBrieBehavior
  include QualityMethods

  def update
    increase_quality(1)
    decrease_sell_in
    increase_quality(1) if @item.sell_in.negative?
  end
end

module BackstageBehavior
  include QualityMethods

  def update
    if @item.sell_in <= 5
      increase_quality(3)
    elsif @item.sell_in <= 10
      increase_quality(2)
    else
      increase_quality(1)
    end
    decrease_sell_in
    @item.quality = 0 if @item.sell_in.negative?
  end
end

module SulfurasBehavior
  def update
    # legendary item do not change
  end
end

module ConjuredBehavior
  include QualityMethods

  def update
    if @item.name == "Conjured Fish"
      if @item.sell_in > 5
        decrease_quality(1)
      elsif @item.sell_in > 0
        decrease_quality(5)
      else
        decrease_quality(4)
      end
    else
      decrease_quality(@item.sell_in.positive? ? 2 : 4)
    end
    decrease_sell_in
  end
end

class NormalItemUpdater
  include NormalBehavior
  def initialize(item); @item = item; end
end

class AgedBrieUpdater
  include AgedBrieBehavior
  def initialize(item); @item = item; end
end

class BackstagePassUpdater
  include BackstageBehavior
  def initialize(item); @item = item; end
end

class SulfurasUpdater
  include SulfurasBehavior
  def initialize(item); @item = item; end
end

class ConjuredUpdater
  include ConjuredBehavior
  def initialize(item); @item = item; end
end

class UpdaterFactory
  def self.for(item)
    case item.name
    when "Aged Brie"
      AgedBrieUpdater.new(item)
    when "Backstage passes to a TAFKAL80ETC concert"
      BackstagePassUpdater.new(item)
    when "Sulfuras, Hand of Ragnaros"
      SulfurasUpdater.new(item)
    when /^Conjured/
      ConjuredUpdater.new(item)
    else
      NormalItemUpdater.new(item)
    end
  end
end

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      UpdaterFactory.for(item).update
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

  def to_s
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
