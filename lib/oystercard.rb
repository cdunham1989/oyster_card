# pointless comment for rubocop
class Oystercard
  attr_reader :balance, :in_journey

  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_FARE = 1

  def initialize(balance = 0, max_balance = MAX_BALANCE, in_journey = false, min_balance = MIN_BALANCE)
    @balance = balance
    @max_balance = max_balance
    @min_balance = min_balance
    @in_journey = in_journey
  end

  def top_up(amount)
    raise "Max balance of #{@max_balance} exceeded!" if balance + amount > @max_balance
    @balance += amount
  end

  def touch_in
    raise "Insufficient funds!" if @balance < @min_balance
    @in_journey = true
  end

  def touch_out
    deduct(MIN_FARE)
    @in_journey = false
  end

private

def deduct(amount)
  @balance -= amount
end

end
