require 'station'

describe Station do
  subject(:station) {described_class.new("Aldgate", 1)}


  it 'records a stations name' do
    expect(station.name).to eq "Aldgate"
  end

  it 'records a stations zone' do
    expect(station.zone).to eq 1
  end
end
