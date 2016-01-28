require 'journey'

describe Journey do
  subject(:journey){described_class.new(station)}
  let(:station) {double(:station, :name => "Oxford Circus", :zone => 1)}
  let(:station_2) {double(:station_2, :name => "Euston", :zone => 2)}
  let(:station_3) {double(:station_3, :name => "Cockfosters", :zone => 5)}



  describe '#initialize' do

    it 'records an entry station' do
      expect(journey.entry_station).to eq(station)
    end

  end

  describe '#end_journey' do

    it 'records an exit station' do
      journey.end_journey(station)
      expect(journey.exit_station).to eq(station)
    end

  end

  describe '#fare' do
    it 'returns the minimum fare after a valid journey' do
        journey.end_journey(station)
        expect(journey.calculate_fare).to eq Oystercard::MIN_FARE
    end

    it 'calculates the correct fare' do
        expect(journey.end_journey(station_2)).to eq Oystercard::MIN_FARE + (station.zone - station_2.zone).abs * Oystercard::ZONE_FARE
    end

    it 'calculates the correct fare' do
        expect(journey.end_journey(station_3)).to eq Oystercard::MIN_FARE + (station.zone - station_3.zone).abs * Oystercard::ZONE_FARE
    end

    context 'it is an invalid journey' do

      it 'charges the penalty fare when theres no valid entry station' do
        journey = Journey.new(nil)
        expect(journey.calculate_fare).to eq Oystercard::PENALTY_FARE
      end

      it 'charges the penalty fare when there is no valid exit station' do
        expect(journey.calculate_fare).to eq Oystercard::PENALTY_FARE
      end

    end

  describe '#complete?' do

      it 'returns true when there is an exit and entry station' do
        journey.end_journey(station)
        expect(journey).to be_complete
      end

      it 'returns false if there is not an entry station' do
        journey = Journey.new(nil)
        expect(journey).not_to be_complete
      end

      it 'returns false if there is not an exit station' do
        expect(journey).not_to be_complete
      end

  end

  end

end
