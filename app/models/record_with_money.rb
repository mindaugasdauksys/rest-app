# money actions in models
module RecordWithMoney
  def money
    @money ||= Money.new(amount, currency)
  end

  def money=(money)
    self.amount = money.amount
    self.currency = money.currency
    @money = money
  end
end
