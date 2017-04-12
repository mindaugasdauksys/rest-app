class Account < ApplicationRecord
  validates_inclusion_of :currency, in: ['EUR', 'USD']
  after_initialize :init

  def init
    self.currency ||= 'EUR'
  end
end
