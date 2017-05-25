# authenticable user definiton
class User < ApplicationRecord
  has_secure_password

  def confirmation_token_valid?
    (self.confirmation_sent_at + 30.days) > Time.now.utc
  end

  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Token.now.utc
    save
  end
end
