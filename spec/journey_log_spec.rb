require 'journey_log'

describe JourneyLog do
  let(:station) {double(:station, :name => "Oxford Circus", :zone => 1)}
  let(:journey) {double(:journey, entry_station: nil, end_journey: nil, calculate_fare: Oystercard::MIN_FARE)}
  let(:journey_klass) {double(:journey_klass, new: journey)}
  subject(:journey_log){described_class.new(journey_klass: journey_klass)}




  describe '#start_journey' do

    it 'creates a new journey instance' do
      expect(journey_klass).to receive(:new).with(entry_station: station)
      journey_log.start_journey(station)
    end

  end

  describe '#end_journey' do
    before {journey_log.start_journey(station)}

    it 'ends the current journey' do
      expect(journey).to receive(:end_journey).with(exit_station: station)
      journey_log.end_journey(station)
    end

    it 'records the completed journey' do
      journey_log.end_journey(station)
      expect(journey_log.journeys).to include(journey)
    end

  end

  describe '#outstanding_charges' do

    context 'there is a complete journey' do
      before do
        journey_log.start_journey(station)
        journey_log.end_journey(station)
      end

      it 'returns the fare for a complete journey' do
        expect(journey_log.outstanding_charges).to eq(1)
      end

    end

    context 'the journey does not have an entry station' do
      let(:journey) {double(:journey, entry_station: nil, end_journey: nil, calculate_fare: Oystercard::PENALTY_FARE)}
      before {journey_log.end_journey(station)}

      it 'returns the penalty for an incomplete journey' do
        expect(journey_log.outstanding_charges).to eq Oystercard::PENALTY_FARE
      end

    end

    context 'the journey does not have an exit station' do
      let(:journey) {double(:journey, entry_station: nil, end_journey: nil, calculate_fare: Oystercard::PENALTY_FARE)}
      before {journey_log.start_journey(station)}

      it 'returns the penalty for an incomplete journey' do
        expect(journey_log.outstanding_charges).to eq Oystercard::PENALTY_FARE
      end
    end

  end


end
