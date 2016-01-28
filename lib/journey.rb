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
    complete? ? Oystercard::MIN_FARE + calculate_zones : Oystercard::PENALTY_FARE
  end

  def complete?
    !!@entry_station && !!@exit_station
  end

  def calculate_zones
    (@entry_station.zone - @exit_station.zone).abs * Oystercard::ZONE_FARE
  end

end
