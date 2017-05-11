# authenticable user definiton
class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  def self.valid_login?(username, password)
    if (user = User.find_by(username: username))
      puts 'USER EXISTS'
      if user.authenticate(password)
        user
      else
        puts "USER PASSWORD: #{user.password_digest} GIVEN: #{password}"
      end
    else
      puts 'USER DOESNT EXIST'
    end
  end

  def create_token 
    regenerate_auth_token
  end

  def logout
    invalidate_auth_token
  end

  private

  def invalidate_auth_token
    update_columns(auth_token: nil)
  end
end
