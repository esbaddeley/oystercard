require 'oystercard'

describe Oystercard do
  let(:entry_station) { double(:station, :name => "Aldgate East", :zone => 1)}
  let(:exit_station) { double(:station, :name => "Old Street", :zone => 2)}

  subject(:oystercard) { described_class.new }

  it 'has a default balance of 0' do
    expect(oystercard.balance). to eq 0
  end

  it 'keeps track of journeys' do
    expect(oystercard.return_journeys).to be_empty
  end

  describe '#top_up' do

    it 'tops up the oystercard by the amount passed in' do
      expect{oystercard.top_up(5)}.to change{oystercard.balance}.by 5
    end

    it 'raises an error if the user tries to exceed the maximum balance' do
      oystercard.top_up(Oystercard::MAX_BALANCE)
      expect{oystercard.top_up(1)}.to raise_error "You may not exceed £#{Oystercard::MAX_BALANCE}"
    end
  end

  describe '#in_journey?' do

    it 'defaults to false' do
      expect(oystercard).to_not be_in_journey
    end

    it 'returns true if the oystercard has been touched in' do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
      expect(oystercard).to be_in_journey
    end

  end

  describe '#touch_in' do

    context 'oystercard is topped up' do
      before do
        oystercard.top_up(1)
      end

      it 'sets the oyster card to be in journey' do
        expect{oystercard.touch_in(entry_station)}.to change{oystercard.in_journey?}.to true
      end

    end

    context 'when balance is under £1' do
      it 'raises an error' do
        expect{oystercard.touch_in(entry_station)}.to raise_error 'Balance is too low'
      end

    end

    context 'oystercard was not touched out' do
      before do
        oystercard.top_up(50)
        oystercard.touch_in(entry_station)
      end

        it 'deducts a penalty fare' do
          expect{oystercard.touch_in(entry_station)}.to change{oystercard.balance}.by -(Oystercard::PENALTY_FARE)
        end


    end

  end

  describe '#touch_out' do
    before do
      oystercard.top_up(1)
      oystercard.touch_in(entry_station)
    end

    it 'sets the oyster card to no longer be in journey' do
      expect{oystercard.touch_out(exit_station)}.to change{oystercard.in_journey?}.to false
    end

    it 'deducts the minimum amount' do
      expect{oystercard.touch_out(entry_station)}.to change{oystercard.balance}.by (-Oystercard::MIN_FARE)
    end

    context 'oystercard was not touched in' do
      before {oystercard.touch_out(exit_station)}

      it 'deducts the penalty fare' do
        expect{oystercard.touch_out(exit_station)}.to change{oystercard.balance}.by (-Oystercard::PENALTY_FARE)
      end

    end

    it 'records a journey' do
      oystercard.touch_in(entry_station)
      oystercard.touch_out(exit_station)
      expect(oystercard.return_journeys.pop).to have_attributes(:entry_station => entry_station, :exit_station => exit_station)
    end
  end

end
