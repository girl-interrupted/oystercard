require 'oystercard'

describe Oystercard do
  # let(:entry_station) {"Victoria"} - if we don't want to use doubles because we are not planning to create new classes
  # let(:exit_station) {"Arsenal"} - we can just assign values with the string
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

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
      expect(subject.in_journey?).to eq false
    end 
  end

  describe '#touch_in' do
    it 'changes in_journey to true' do
      subject.top_up(2)
      subject.touch_in(entry_station)
      expect(subject.in_journey?).to eq true
    end
    it 'fails if the balance is less than £1' do
      expect{ subject.touch_in(entry_station) }.to raise_error ("Your balance is less than £1")
    end
    it 'saves the entry station after the touch in' do
      subject.top_up(5)
      subject.touch_in(entry_station)
      expect(subject.entry_station).to eq entry_station
    end
  end

  describe '#touch_out' do
    it 'changes in_journey to false' do
      subject.top_up(2)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.in_journey?).to eq false
    end
    it 'deducts the minimum fare from balance' do
      subject.top_up(5)
      subject.touch_in(entry_station)
      expect {subject.touch_out(exit_station)}.to change {subject.balance}.by(-Oystercard::MIN_FARE)
    end
    it 'saves the exit station to instance variable' do
      subject.top_up(4)
      subject.touch_in(entry_station)
      subject.touch_out(exit_station)
      expect(subject.exit_station).to eq(exit_station)
    end
  end

  describe '@journeys' do    
    it 'it contains an empty list of all journeys' do
      expect(subject.journeys).to be_empty
    end

  let(:journey){ {entry_station: entry_station, exit_station: exit_station} }
    it 'stores a journey' do
    subject.top_up(Oystercard::MIN_BALANCE)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journeys).to include journey
  end
end

end