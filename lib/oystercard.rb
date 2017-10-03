# pointless comment for rubocop
class Oystercard
  attr_reader :balance, :in_journey

  MAX_BALANCE = 90

  def initialize(balance = 0, max_balance = MAX_BALANCE, in_journey = false)
    @balance = balance
    @max_balance = max_balance
    @in_journey = in_journey
  end

  def top_up(amount)
    raise "Max balance of #{@max_balance} exceeded!" if balance + amount > @max_balance
    @balance += amount
    # @balance = @balance + amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end
end
