require 'oystercard'

describe Oystercard do
  describe '@balance' do
    it 'tells the customer their balance' do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'increases the balance of Oystercard' do
      subject.top_up(20)
      expect(subject.balance).to eq 20
    end

    it 'throws an error if customer tries to increase credit above 90' do
      card = Oystercard.new
      card.top_up(80)
      expect{ card.top_up(20) }.to raise_error 'Your credit cannot go over 90'
    end
  end
end