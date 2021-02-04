class Oystercard
  LIMIT = 90
  MIN_BALANCE = 1
  MIN_FARE = 2

  attr_reader :balance, :entry_station, :journeys, :exit_station

  def initialize(balance = 0)
    @balance = balance
    @entry_station = entry_station
    @exit_station = exit_station
    @journeys = []
  end

  def top_up(amount)
    fail "Your credit cannot go over #{LIMIT}" if amount > LIMIT - @balance
    @balance += amount
  end

  def touch_in(entry_station)
    fail "Your balance is less than £1" if @balance < MIN_BALANCE
    @entry_station = entry_station
  end

  def touch_out(exit_station)
    deduct(MIN_FARE)
    @journeys.append({entry_station: entry_station, exit_station: exit_station})
    @entry_station = nil
    @exit_station = exit_station
  end

  def in_journey?
    !!entry_station 
    # returns true when user touches in (because we use a string), 
    # and returns false when user touches out, because entry_station = nil and !!nil returns false
  end

  private
  def deduct(amount)
    @balance -= amount
  end
end
