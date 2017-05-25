class Transaction < ApplicationRecord
  belongs_to :sender, class_name: 'Account'
  belongs_to :recipient, class_name: 'Account'

  validates :sender, presence: true
  validates :recipient, presence: true
  validates :amount, presence: true

  validate :sender_and_recipient_differ
  validate :sufficient_sender_balance

  before_save :modify_balances
  before_destroy :reset_balances

  private
    def sender_and_recipient_differ
      if sender == recipient
        errors.add(:sender, 'cannot create a transaction to self')
      end
    end

    def sufficient_sender_balance
      if sender && sender.balance < amount
        errors.add(:sender, 'balance is lower than the requested transaction amount')
      end
    end

    def modify_balances
      sender.balance -= amount
      sender.save!
      recipient.balance += amount
      recipient.save!
    end

    def reset_balances
      sender.balance += amount
      sender.save!
      recipient.balance -= amount
      recipient.save!
    end
end
