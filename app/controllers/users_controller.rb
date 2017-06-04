# users controller
class UsersController < ApplicationController
  def create
    user = UserRegistration.new(user_params)
    if user.register
      head :ok
    else
      head :bad_request
    end
  end

  def confirm
    token = params[:token].to_s
    user = User.find_by(confirmation_token: token)

    if user.present? && user.confirmation_token_valid?
      user.mark_as_confirmed
      head :ok
    else
      head :not_found
    end
  end

  def login
    user = User.find_by(username: params[:username].to_s.downcase)

    if user && user.authenticate(params[:password])
      auth_token = JsonWebToken.encode(user_id: user.id, mode: user.mode)
      render json: { auth_token: auth_token }, status: :ok
    else
      head :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password,
                                 :password_confirmation, :mode)
  end
end
