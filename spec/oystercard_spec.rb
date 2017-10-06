require 'oystercard'

describe Oystercard do
  let(:journey){ double('journey', fare: 1, finish: self) }
  let(:journey_class){ class_double('Journey', new: journey)}
  subject(:oystercard) { described_class.new(journey_class) }
  let(:station) { double :station }

  context 'managing balance' do
    it 'a new card has a balance of 0' do
      expect(oystercard.balance).to eq(0)
    end

    it 'changes balance when topped up' do
      expect { oystercard.top_up 2 }.to change { oystercard.balance }.by 2
    end

    it 'prevents balance exceeding 90' do
      max_balance = Oystercard::MAX_BALANCE
      oystercard.top_up(max_balance)
      expect { oystercard.top_up(4) }.to raise_error "Max balance of #{max_balance} exceeded!"
    end
  end

  context 'journey status' do
    let(:entry_station) { double :station }
    let(:exit_station) { double :station }

    it 'has an empty list of journeys by default' do
      expect(subject.journey_history).to be_empty
    end

    it 'stores a journey' do
      oystercard.top_up(1)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journey_history).to include journey
    end

    it 'still stores a journey if not touched out' do
      oystercard.top_up(2)
      subject.touch_in(entry_station)
      subject.touch_in(entry_station)
      expect(subject.journey_history).to include journey
    end

    it 'still stores a journey if not touched in' do
      oystercard.top_up(1)
      subject.touch_out(exit_station)
      expect(subject.journey_history).to include journey
    end
  end

  context 'charging the card' do
    let(:entry_station) { double :station }
    let(:exit_station) { double :station }

    it 'should reduce the balance by the fare on touch out' do
      oystercard.top_up(1)
      subject.touch_in(entry_station)
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-1)
    end

    it 'deducts penalty if dont touch in' do
      allow(journey).to receive(:fare).and_return(6)
      oystercard.top_up(6)
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-6)
    end

    it 'deducts penalty if dont touch out' do
      allow(journey).to receive(:fare).and_return(6)
      oystercard.top_up(6)
      subject.touch_in(entry_station)
      expect { oystercard.touch_in(entry_station) }.to change { oystercard.balance }.by(-6)
    end
  end

  context 'error raising' do
    it 'raises an error if touching in when balance is too low' do
      expect { oystercard.touch_in(station) }.to raise_error('Insufficient funds!')
    end
  end
end
