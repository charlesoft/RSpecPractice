require 'deck'

describe 'Deck' do

  describe '.all' do
    it 'contains 32 cards' do
      expect(Deck.all.length).to eq(32)
    end

    it 'has a seven as its lowest card' do
      # Deck::SUITS.each do |suit|
      #   expect(Deck.all).to include(Card.build(suit, 7))
      #   expect(Deck.all).to_not include(Card.build(suit, 6))
      # end
      # Deck.all.each do |card|
      #   expect(card.rank).to be >= 7
      # end
      # expect(Deck.all.map { |card| card.rank }).to all(be >= 7)
      expect(Deck.all).to all(have_attributes(rank: be >= 7))
    end
  end
end
