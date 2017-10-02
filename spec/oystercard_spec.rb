require 'oystercard'

describe Oystercard do

  it 'a new card has a balance of 0' do
    expect(subject.balance).to eq(0)
  end

  it 'can be topped up' do
     expect(subject).to respond_to(:top_up).with(1).argument
  end

  it 'changes balance when topped up' do
    expect{ subject.top_up 2 }.to change{ subject.balance }.by 2
  end

end
