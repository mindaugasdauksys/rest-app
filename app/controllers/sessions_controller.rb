class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create, :new], raise: false
  skip_before_action :verify_authenticity_token
  def create
    session_params = params.require(:session)
    if (user = User.valid_login?(session_params[:username], session_params[:password]))
      user.create_token
      helpers.remember(user)
      redirect_to :accounts
    else
      render :new
    end
  end

  def new
    if current_user
      redirect_to :accounts
    end
  end

  def destroy
    current_user.logout
    helpers.forget
    respond_to do |format|
      format.html { redirect_to :start_page }
      format.any { head :ok }
    end
  end
end
