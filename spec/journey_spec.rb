require 'journey'

describe Journey do

  describe '#initialize' do
    subject(:journey){described_class.new(station)}
    let(:station) {double(:station)}

    it 'records an entry station' do
      expect(journey.entry_station).to eq(station)
    end

  end

  describe '#end_journey' do
    subject(:journey){described_class.new(station)}
    let(:station) {double(:station)}

    it 'records an exit station' do
      journey.end_journey(station)
      expect(journey.exit_station).to eq(station)
    end

  end


end
