require_relative 'oystercard'

class Journey

  attr_reader :entry_station, :exit_station

  def initialize(station=nil)
    @entry_station = station
  end

  def end_journey(station)
    @exit_station = station
  end

  def calculate_fare
    entry_station == nil || exit_station == nil ? Oystercard::PENALTY_FARE : Oystercard::MIN_FARE
  end
end
