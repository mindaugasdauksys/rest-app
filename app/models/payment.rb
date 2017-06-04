# payment model
class Payment < ApplicationRecord
  validates_presence_of :from
  validates_presence_of :to
  validates_presence_of :amount
  validates_presence_of :currency
  validates_inclusion_of :currency, in: %w[EUR USD]
  include RecordWithMoney
end
