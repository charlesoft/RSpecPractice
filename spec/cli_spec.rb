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

  example 'not betting on losing hand' do
    # External dependencies
    allow(HighCard::CLI).to receive(:puts)
    allow(HighCard::CLI).to receive(:print)
    allow(HighCard::CLI).to receive(:`).with("whoami").and_return("tester")
    allow_any_instance_of(HighCard::Bank).to receive(:accounts).and_return([
      FakeAccount.new
      ])

      # Set up states
      allow(Card).to receive(:build).and_return(*
        [Card.build(:clubs, 7)] * 5 + # Waker hand
        [Card.build(:clubs, 8)] * 5  # Stronger hand
      )

      allow_any_instance_of(Array).to receive(:shuffle) { |x| x }

      expect($stdin).to receive(:gets).and_return("N")
      expect(HighCard::CLI).to receive(:puts).with("You won!")

      HighCard::CLI.run
    end
  end
