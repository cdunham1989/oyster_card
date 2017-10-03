require 'oystercard'

describe Oystercard do
  subject(:oystercard) { described_class.new }

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

  it 'changes balance when topped up' do
    expect { oystercard.deduct 2 }.to change { oystercard.balance }.by -2
  end

  it 'tells us if a journey is in progress' do
    expect(oystercard.in_journey).to eq(true).or eq(false)
  end

  it 'allows us to touch in' do
    oystercard.touch_in
    expect(oystercard.in_journey).to eq(true)
  end
end
