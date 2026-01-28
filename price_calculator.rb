PRICING_RULES = {
  milk:   { unit_price: 3.97, offer_quantity: 2, offer_price: 5.00 },
  bread:  { unit_price: 2.17, offer_quantity: 3, offer_price: 6.00 },
  apple:  { unit_price: 0.89 },
  banana: { unit_price: 0.99 }
}

class PriceCalculator
  def initialize(items)
    @items = items
  end

  def run
    counts = item_counts
    totals = calculate_totals(counts)
    print_receipt(counts, totals)
  end

  private

  def item_counts
    counts = Hash.new(0)
    @items.each { |item| counts[item] += 1 }
    counts
  end

  def calculate_totals(counts)
    totals = {}

    counts.each do |item, quantity|
      rule = PRICING_RULES[item]
      totals[item] = calculate_item_total(rule, quantity)
    end

    totals
  end

  def calculate_item_total(rule, quantity)
    return rule[:unit_price] * quantity unless rule[:offer_quantity]

    offer_sets = quantity / rule[:offer_quantity]
    remainder  = quantity % rule[:offer_quantity]

    (offer_sets * rule[:offer_price]) +
      (remainder * rule[:unit_price])
  end

  def print_receipt(counts, totals)
    total_price = 0.0
    original_price = 0.0

    totals.each do |item, price|
      quantity = counts[item]
      unit_price = PRICING_RULES[item][:unit_price]

      total_price += price
      original_price += unit_price * quantity

      puts "#{item.to_s.capitalize.ljust(8)} #{quantity.to_s.ljust(10)} $#{format('%.2f', price)}"
    end

    puts "Total price : $#{format('%.2f', total_price)}"
    puts "You saved $#{format('%.2f', original_price - total_price)}"
  end
end
puts "Please enter all the items purchased separated by a comma"
input = gets.chomp

items = input.split(",").map { |item| item.strip.downcase.to_sym }

PriceCalculator.new(items).run