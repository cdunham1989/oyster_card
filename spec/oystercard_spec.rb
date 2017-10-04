require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:station) { double :station }

  context 'managing balance' do
    it 'a new card has a balance of 0' do
      expect(oystercard.balance).to eq(0)
    end

    it 'can be topped up' do
      expect(oystercard).to respond_to(:top_up).with(1).argument
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
    let(:journey){ { entry_station: entry_station, exit_station: exit_station } }
    let(:entry_station) { double :station }
    let(:exit_station) { double :station }

    it 'tells us if a journey is in progress' do
      expect(oystercard.in_journey).to eq(true).or eq(false)
    end

    it 'has an empty list of journeys by default' do
      expect(subject.journeys).to be_empty
    end

    it 'stores a journey' do
      oystercard.top_up(1)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.journeys).to include journey
    end
  end

  context 'charging the card' do
    let(:exit_station) { double :station }

    it 'should reduce the balance by minimum fare on touch out' do
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-Oystercard::MIN_FARE)
    end
  end

  context 'error raising' do
    it 'raises an error if touching in when balance is too low' do
      expect { oystercard.touch_in(station) }.to raise_error('Insufficient funds!')
    end
  end

  context 'station storing' do
    let(:entry_station) { double :station }

    it 'stores the entry station' do
      oystercard.top_up(5)
      oystercard.touch_in(entry_station)
      expect(subject.entry_station).to eq entry_station
    end
  end
end
