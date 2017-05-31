class Account < ApplicationRecord
  validates_presence_of :currency
  validates_presence_of :name
  validates_presence_of :surname
  validates_presence_of :amount
  validates_inclusion_of :currency, in: ['EUR', 'USD']
  after_initialize :init
  include RecordWithMoney
  def init
    self.currency ||= 'EUR'
  end
end
