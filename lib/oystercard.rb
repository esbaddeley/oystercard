require_relative 'journey'

class Oystercard
  attr_reader :balance, :journeys

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_FARE = 1
  PENALTY_FARE = 6

  def initialize(balance = DEFAULT_BALANCE)
    @balance = balance
    @journeys = []
  end

  def top_up(amount)
    raise "You may not exceed £#{MAX_BALANCE}" if @balance + amount > MAX_BALANCE
    @balance += amount
  end

  def in_journey?
    !!@current_journey
  end

  def touch_in(station)
    raise 'Balance is too low' if @balance < MIN_BALANCE
    deduct(@current_journey.calculate_fare) if in_journey?
    @current_journey = Journey.new(station)
  end

  def touch_out(station)
    @current_journey = Journey.new(nil) if !in_journey?
    @current_journey.end_journey(station)
    deduct(@current_journey.calculate_fare)
    @journeys << @current_journey
    @current_journey = nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end
  #test change
end
