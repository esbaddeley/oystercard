class JourneyLog

  attr_reader :entry_station, :current_journey

  def initialize(journey_klass: Journey)
    @journey_klass = journey_klass
    @journeys = []
  end

  def start_journey(entry_station)
     @current_journey = @journey_klass.new(entry_station: entry_station)
     @journeys << @current_journey
  end

  def end_journey(exit_station)
    if @current_journey
      @journeys[-1].end_journey(exit_station: exit_station)
    else
      @current_journey = @journey_klass.new(entry_station: nil)
      @journeys << @current_journey
      @journeys[-1].end_journey(exit_station: exit_station)
    end
    @current_journey = nil
  end

  def outstanding_charges
    if !@journeys[-1].complete?
      @journeys << @current_journey
      @current_journey = nil
    end
    @journeys.[-1].calculate_fare
  end

  def journeys
    @journeys.dup
  end

end
