module SessionsHelper
  def remember(user)
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:auth_token] = user.auth_token
  end

  def forget
    cookies.delete(:user_id)
    cookies.delete(:auth_token)
  end
end
