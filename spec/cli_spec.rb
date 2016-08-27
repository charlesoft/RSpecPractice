require 'high_card'
require 'card'

BIN = File.expand_path("../../bin/play", __FILE__)

describe 'CLI', :acceptance do

  class FakeAccount
    def name; "tester"; end
    def credit!(*_); end
    def debit!(*_); end
    def balance; end
  end

  class LowHandFirstDeck
    def initialize
      @cards =
          [Card.build(:clubs, 7)] * 5 + # Weaker hand
          [Card.build(:clubs, 8)] * 5 # Stronger hand
    end

    def shift(n)
      @cards.shift(n)
    end
  end


  example 'not betting on losing hand' do
    # External dependencies
    allow(HighCard::CLI).to receive(:`).with("whoami").and_return("tester")
    allow_any_instance_of(HighCard::Bank).to receive(:accounts).and_return([
      FakeAccount.new
      ])

      ui = instance_double(HighCard::UI).as_null_object
      expect(ui).to receive(:yesno_prompt).with("Bet 1$ to win?").and_return(false)
      expect(ui).to receive(:puts).with("You won!")

      expect(HighCard::Round).to receive(:win?).and_return(true)


      HighCard::CLI.run(1, ui: ui)
    end
  end
