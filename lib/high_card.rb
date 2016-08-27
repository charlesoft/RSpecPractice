require 'card'
require 'deck'
require 'fileutils'

module HighCard
  def self.beats?(hand, opposing)
    winning  = [hand, opposing]
      .sort_by {|h| h.map(&:rank).sort.reverse }
      .last
    hand == winning
  end

  class CLI
    def self.run(seed=rand(100000), deck: Deck.new, ui: UI.new)
      Kernel.srand seed.to_i

      login = `whoami`.chomp
      bank = Bank.new(ENV.fetch('HIGHCARD_DIR', "/tmp/bank-accounts"))
      account = bank.accounts.detect {|x| x.name == login }
      if !account
        puts "Could not find bank account, you cannot play"
        return
      end

      hand     = deck.deal(5).sort_by(&:rank).reverse
      opposing = deck.deal(5).sort_by(&:rank).reverse

      ui.puts "Your hand is       #{hand.join(", ")}"
      print "Bet $1 to win? N/y: "
      start = Time.now
      input = ui.yesno_prompt("Bet 1$ to win?")#$stdin.gets
      if Round.win?(input, hand, opposing)
        ui.puts "You won!"
        account.credit!(login, 1)
      else
        puts "You lost!"
        account.debit!(login, 1)
      end
      ui.puts "Opposing hand was  #{opposing.join(", ")}"
      ui.puts "Balance is #{account.balance}"
      ui.puts "You took #{Time.now - start}s to make a decision."
    end
  end

  class UI
    def yesno_prompt(message)
      print message + "Y/n"
      input = $stdin.gets
      input[0].downcase == "n"
    end

    def puts(message)
      $stdout.puts message
    end
  end

  class Round
    def self.win?(bet,hand,opposing)
      winning = [hand, opposing]
        .sort_by {|h| h.map(&:rank).sort.reverse }
        .last

      bet && hand == winning || !bet && opposing == winning
      # bet ^ (opposing == winning)
    end
  end

  class Bank
    class Account
      attr_reader :name, :balance

      def initialize(path, name)
        @path = path
        FileUtils.mkdir_p(path)
        @name = name
        @balance = File.read(path + "/#{name}").to_i rescue 0
      end

      def debit!(account, amount)
        raise if account != name
        @balance -= amount
        write!
      end

      def credit!(account, amount)
        raise if account != name
        @balance += amount
        write!
      end

      private

      def write!
        File.write(@path + "/#{name}", balance)
      end
    end

    def initialize(path)
      @path = path
    end

    def accounts
      [Account.new(@path, "xavier")]
    end
  end
end
