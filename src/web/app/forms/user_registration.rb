# user registration
class UserRegistration
  include ActiveModel::Model

  attr_accessor :username, :password, :password_confirmation, :mode

  validates :username, length: { in: 4..20 }
  validates :password, length: { minimum: 6 }

  def register
    p 'I am registering'
    return false unless valid?
    p 'valid'
    User.create!(username: username,
                 password: password,
                 password_confirmation: password_confirmation,
                 mode: mode)
    p 'completed'
    true
  end
end
