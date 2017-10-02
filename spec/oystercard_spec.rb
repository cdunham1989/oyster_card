require 'oystercard'

describe Oystercard do

  it 'a new card has a balance of 0' do
    expect(subject.balance).to eq(0)
  end

  it 'can be topped up to change balance' do
     expect(subject).to respond_to(:top_up).with(1).argument
  end

end
