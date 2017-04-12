class Account < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :surname
  validates_presence_of :money
end
