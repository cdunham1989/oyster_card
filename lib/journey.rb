# pointless comment for rubocop
class Journey
  attr_reader :entry_station, :exit_station

  MIN_FARE = 1
  PENALTY_FARE = 6

  def initialize(entry_station = nil)
    @entry_station = entry_station
    @complete = false
  end

  def finish(exit_station)
    @exit_station = exit_station
    @complete = true
    self
  end

  def fare
    @entry_station && @exit_station ? MIN_FARE : PENALTY_FARE
  end

  private

  def complete?
    @complete
  end
end
