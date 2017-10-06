require 'journey'
describe Journey do
  let(:station) { double('station')}

  it 'has a penalty fare by default' do
    expect(subject.fare).to eq Journey::PENALTY_FARE
  end

  it "returns itself when exiting a journey" do
    expect(subject.finish(station)).to eq(subject)
  end

  context 'given an entry station' do
    subject { described_class.new(station) }

    it 'has an entry station' do
      expect(subject.entry_station).to eq station
    end

    it "returns a penalty fare if no exit station given" do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end

    context 'given an exit station' do
      let(:exit_station) { double :exit_station }

      it 'calculates a fare' do
        # journey = Journey.new('Bank')
        subject.finish(exit_station)
        expect(subject.fare).to eq 1
      end
    end
  end
end
