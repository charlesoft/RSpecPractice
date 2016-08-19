require 'card'

module HighCard
  def self.beats?(hand, opposing)
    # hand.map(&:rank).sort.last > opposing.map(&:rank).sort.last
    winning = [hand, opposing]
      .sort_by { |h| h.map(&:rank).sort.reverse }
      .last
    puts "Array of winning: #{winning}"
    hand == winning
  end
end
