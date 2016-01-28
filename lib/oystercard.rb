require_relative 'journey'

class Oystercard

  attr_reader :balance

  DEFAULT_BALANCE = 0
  MAX_BALANCE = 90
  MIN_BALANCE = 1
  MIN_FARE = 1
  ZONE_FARE = 1
  PENALTY_FARE = 6

  def initialize(balance = DEFAULT_BALANCE, journey_log_klass = JourneyLog)
    @balance = balance
    @journeys = []
    @journey_log_klass = journey_log_klass.new
  end

  def top_up(amount)
    max_balance_error(amount)
    @balance += amount
  end

  def in_journey?
    !!@current_journey
  end

  def touch_in(station)
    balance_too_low_error
    @journey_log_klass.start_journey(station)
    deduct(@current_journey.calculate_fare)
  end

  def touch_out(station)
    create_a_journey(nil) if !in_journey?
    deduct(@current_journey.end_journey(station))
    add_to_journey_history
  end

  def return_journeys
    @journeys.dup
  end


  private

  attr_reader :journeys

  def deduct(amount)
    @balance -= amount
  end

  def add_to_journey_history
    @journeys << @current_journey
    @current_journey = nil
  end

  def max_balance_error(amount)
    raise "You may not exceed £#{MAX_BALANCE}" if @balance + amount > MAX_BALANCE
  end

  def balance_too_low_error
    raise 'Balance is too low' if @balance < MIN_BALANCE
  end

  def create_a_journey(station)
    station == nil ? @current_journey = Journey.new(nil) : @current_journey = Journey.new(station)
  end




end
