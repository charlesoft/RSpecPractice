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
    allow(HighCard::CLI).to receive(:puts)
    allow(HighCard::CLI).to receive(:print)
    allow(HighCard::CLI).to receive(:`).with("whoami").and_return("tester")
    allow_any_instance_of(HighCard::Bank).to receive(:accounts).and_return([
      FakeAccount.new
      ])

      expect(HighCard::Round).to receive(:win?)
        .with(false, any_args)
        .and_return(true)

      expect($stdin).to receive(:gets).and_return("N")
      expect(HighCard::CLI).to receive(:puts).with("You won!")

      HighCard::CLI.run(1)
    end
  end
