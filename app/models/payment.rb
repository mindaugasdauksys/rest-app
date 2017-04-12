class Payment < ApplicationRecord
  validates_presence_of :from
  validates_presence_of :to
  validates_presence_of :amount
end
