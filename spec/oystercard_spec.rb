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
 
    it 'make top_up throw error if balance would be bigger than new limit' do
      maximum_balance = Oystercard::LIMIT
      subject.top_up(maximum_balance)
      expect{ subject.top_up(1) }.to raise_error("Your credit cannot go over #{maximum_balance}")
    end
  end

  describe 'in_journey' do
    it 'checks it starts as false before beginning of the journey' do
      expect(subject.in_journey).to eq false
    end 
  end
  
  describe '#touch_in' do
    it 'changes in_journey to true' do
      subject.top_up(2)
      subject.touch_in
      expect(subject.in_journey).to eq true
    end
    it 'fails if the balance is less than £1' do
      expect{ subject.touch_in }.to raise_error ("Your balance is less than £1")
    end
  end

  describe '#touch_out' do
    it 'changes in_journey to false' do
      subject.top_up(2)
      subject.touch_in
      subject.touch_out
      expect(subject.in_journey).to eq false
    end
    it 'deducts the minimum fare from balance' do
      subject.top_up(5)
      subject.touch_in
      expect {subject.touch_out}.to change {subject.balance}.by(-Oystercard::MIN_FARE)
    end
  end

end