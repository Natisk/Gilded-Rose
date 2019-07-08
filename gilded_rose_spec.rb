require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    # common item ----------------------------------------------------------------------------
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq 'foo'
    end

    it 'does change the quality of item by 1' do
      items = [Item.new('foo', 1, 3)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 2
    end

    it 'does change the sellin of item by 1' do
      items = [Item.new('foo', 1, 3)]
      GildedRose.new(items).update_quality()
      expect(items[0].sell_in).to eq 0
    end

    it 'does not change the quality of item lower than 0' do
      items = [Item.new('foo', 1, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
    end

    # legendary ITEM ------------------------------------------------------------------------
    it 'does not decrease quality of Sulfuras' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 0, 80)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 80
    end

    # Aged Brie case--------------------------------------------------------------------------
    it 'does increases quality of Aged Brie' do
      items = [Item.new('Aged Brie', 0, 30),
               Item.new('Aged Brie', -5, 10),
               Item.new('Aged Brie', 15, 40)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to be > 30
      expect(items[1].quality).to be > 10
      expect(items[2].quality).to be > 40
    end

    it 'does increases quality of Aged Brie by 1 if sell in > 0' do
      items = [Item.new('Aged Brie', 0, 30),
               Item.new('Aged Brie', 5, 10),
               Item.new('Aged Brie', 15, 40)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 32
      expect(items[1].quality).to eq 11
      expect(items[2].quality).to eq 41
    end

    it 'does increases quality of Aged Brie by 2 if sell in <= 0' do
      items = [Item.new('Aged Brie', 0, 30),
               Item.new('Aged Brie', -7, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 32
      expect(items[1].quality).to eq 12
    end

    # Backstage passes case--------------------------------------------------------------------
    it 'does not decrease quality of Backstage passes if sell in > 0' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 2, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to be > 10
    end

    it 'does decrease quality to 0 of Backstage passes if sell in <= 0' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 40),
               Item.new('Backstage passes to a TAFKAL80ETC concert', -2, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 0
      expect(items[1].quality).to eq 0
    end

    it 'increases quality of Backstage passes with by 2 if 5 < sell in <= 10' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 40),
               Item.new('Backstage passes to a TAFKAL80ETC concert', 8, 10),
               Item.new('Backstage passes to a TAFKAL80ETC concert', 6, 20)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 42
      expect(items[1].quality).to eq 12
      expect(items[2].quality).to eq 22
    end

    it 'increases quality of Backstage passes with by 3 if sell in <= 5' do
      items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 40),
               Item.new('Backstage passes to a TAFKAL80ETC concert', 3, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 43
      expect(items[1].quality).to eq 13
    end

    # Conjured items case ---------------------------------------------------------------------
    it 'decreases quality of Conjured twice faster before sellin' do
      items = [Item.new('Conjured Mana Cake', 5, 40),
               Item.new('Bar', 3, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 38
      expect(items[1].quality).to eq 9
    end

    it 'decreases quality of Conjured twice faster after sellin' do
      items = [Item.new('Conjured Mana Cake', -5, 40),
               Item.new('Bar', -3, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 36
      expect(items[1].quality).to eq 8
    end

    it 'decreases quality of Conjured Fish by 5 after sellin is lower than 5' do
      items = [Item.new('Conjured Mana Cake', -5, 40),
               Item.new('Conjured Fish', 5, 10)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 36
      expect(items[1].quality).to eq 5
    end

    it 'decreases quality of Conjured Fish by 1 after sellin is higher than 5' do
      items = [Item.new('Conjured Fish',10, 15)]
      GildedRose.new(items).update_quality()
      expect(items[0].quality).to eq 14
    end
  end
end
