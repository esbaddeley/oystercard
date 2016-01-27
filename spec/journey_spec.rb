require 'journey'

describe Journey do
  subject(:journey){described_class.new(station)}
  let(:station) {double(:station)}

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
