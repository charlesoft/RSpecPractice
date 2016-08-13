require 'spec_helper'
require 'card'
require 'set'

describe Card do

  def card(params ={})
    defaults = {
      suit: :hearts,
      rank: 7
    }
    Card.build(*defaults.merge(params).values_at(:suit, :rank))
  end

  it 'has a suit' do
    raise unless card(suit: :spades).suit == :spades
  end

  it 'has a rank' do
    raise unless  card(suit: :spades, rank: 4).rank == 4
  end

  context 'equality' do
    subject { card(suit: :spades,rank: 4) }
    let(:other) { card(suit: :spades,rank: 4) }

    describe 'comparing against it self' do
      it 'is equal' do
        raise unless subject == other
      end

      it 'its hash equal' do
        raise unless Set.new([subject,other]).size == 1
      end
    end

    shared_examples_for 'an unequal card' do
      it 'is not equal' do
        raise unless subject != other
      end

      it 'its hash not equal' do
        raise unless Set.new([subject,other]).size == 2
      end
    end

    describe 'comparing to a card of different suit' do
      let(:other) { card(suit: :hearts,rank: 5) }

      it_behaves_like 'an unequal card'
    end

    describe 'comparing to a card of different rank' do
      let(:other) { card(suit: :spades,rank: 5) }

      it_behaves_like 'an unequal card'
    end
  end

  describe 'a jack' do
    it 'ranks higher than a 10' do
      lower = card(rank: 10)
      higher = card(rank: :jack)
      raise unless higher.rank > lower.rank
    end
  end

  describe 'a queen' do
    it 'ranks higher than a jack' do
      lower = card(rank: :jack)
      higher = card(rank: :queen)
      raise unless higher.rank > lower.rank
    end
  end

  describe 'a king' do
    it 'ranks higher than a queen' do
      lower = card(rank: :queen)
      higher = card(rank: :king)
      raise unless higher.rank > lower.rank
    end
  end
end
