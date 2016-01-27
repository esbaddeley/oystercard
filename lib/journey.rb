require_relative 'oystercard'

class Journey

  attr_reader :entry_station, :exit_station

  def initialize(station=nil)
    @entry_station = station
  end

  def end_journey(station)
    @exit_station = station
    calculate_fare
  end

  def calculate_fare
    complete? ? Oystercard::MIN_FARE : Oystercard::PENALTY_FARE
  end

  def complete?
    !!@entry_station && !!@exit_station
  end

end
