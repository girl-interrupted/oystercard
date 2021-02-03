class Oystercard
  LIMIT = 90
  MIN_BALANCE = 1
  MIN_FARE = 2

  attr_reader :balance, :entry_station

  def initialize(balance = 0)
    @balance = balance
    @entry_station = entry_station
  end

  def top_up(amount)
    fail "Your credit cannot go over #{LIMIT}" if amount > LIMIT - @balance
    @balance += amount
  end

  def touch_in(station)
    fail "Your balance is less than £1" if @balance < MIN_BALANCE
    @entry_station = station
  end

  def touch_out
    deduct(MIN_FARE)
    @entry_station = nil
  end

  def in_journey
    !!@entry_station
  end

  private
  def deduct(amount)
    @balance -= amount
  end
end
