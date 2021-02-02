class Oystercard
  LIMIT = 90
  attr_reader :balance
  def initialize(balance = 0)
    @balance = balance
  end

  def top_up(amount)
    fail "Your credit cannot go over #{LIMIT}" if amount > LIMIT - @balance
    @balance += amount
  end

end
