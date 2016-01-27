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
        journey.instance_variable_set("@entry_station", nil)

        expect(journey.calculate_fare).to eq Oystercard::PENALTY_FARE
      end



    end

  end

end
