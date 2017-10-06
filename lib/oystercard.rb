# pointless comment for rubocop
require './lib/journey.rb'

class Oystercard
  attr_reader :balance, :journey_history, :journey

  MAX_BALANCE = 90
  MIN_BALANCE = 1

  def initialize(journey_class = Journey)
    @balance = 0
    @journey_history = []
    @journey_class = journey_class
  end

  def top_up(amount)
    raise "Max balance of #{MAX_BALANCE} exceeded!" if balance + amount > MAX_BALANCE
    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Insufficient funds!' if @balance < MIN_BALANCE
    finish_journey if journey
    new_journey(entry_station)
  end

  def touch_out(exit_station)
    new_journey if !@journey
    finish_journey(exit_station)
  end

  private

  def deduct(amount)
    @balance -= amount
  end

  def save_journey(journey)
    @journey_history << journey
  end

  def new_journey(entry_station = nil)
    @journey = @journey_class.new(entry_station)
  end

  def finish_journey(exit_station = nil)
    journey.finish(exit_station)
    deduct(journey.fare)
    save_journey(journey)
  end
end
