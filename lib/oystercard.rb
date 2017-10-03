# pointless comment for rubocop
class Oystercard
  attr_reader :balance

  MAX_BALANCE = 90

  def initialize(balance = 0, max_balance = MAX_BALANCE)
    @balance = balance
    @max_balance = max_balance
  end

  def top_up(amount)
    raise "Max balance of #{@max_balance} exceeded!" if balance + amount > @max_balance
    @balance += amount
    # @balance = @balance + amount
  end

  def deduct(amount)
    @balance -= amount
  end
end
