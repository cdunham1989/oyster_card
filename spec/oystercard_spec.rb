require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let (:station) { double :station }

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
    it 'tells us if a journey is in progress' do
      expect(oystercard.in_journey).to eq(true).or eq(false)
    end

    it 'allows us to touch out' do
      oystercard.top_up(1)
      oystercard.touch_in(station)
      oystercard.touch_out
      expect(oystercard.in_journey).not_to eq nil
    end
  end

  context 'charging the card' do
    it 'should reduce the balance by minimum fare on touch out' do
      expect { oystercard.touch_out }.to change { oystercard.balance }.by (-Oystercard::MIN_FARE)
    end
  end

  context 'error raising' do
    it 'raises an error if touching in when balance is too low' do
      expect { oystercard.touch_in(station) }.to raise_error('Insufficient funds!')
    end
  end

  context 'station storing' do
    it 'stores the entry station' do
      oystercard.top_up(5)
      oystercard.touch_in(station)
      expect(subject.entry_station).to eq station
    end
  end
end
