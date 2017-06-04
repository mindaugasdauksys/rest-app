# create payment policy
class CreatePaymentPolicy
  def initialize(payment)
    @payment = payment
    @account = Account.find_by_id(payment.from)
  end

  def allowed?
    @account && enough_money? && same_currency?
  end

  private

  def same_currency?
    @account.currency.eql? @payment.currency
  end

  def enough_money?
    @account.amount > @payment.amount
  end
end
