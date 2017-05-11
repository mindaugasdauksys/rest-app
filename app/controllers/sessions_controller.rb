class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create, :new], raise: false
  skip_before_action :verify_authenticity_token
  def create
    session_params = params.require(:session)
    if user = User.valid_login?(session_params[:username], session_params[:password])
      user.create_token
      helpers.remember(user)
      redirect_to :accounts
    else
      puts 'I was referred there'
      render :new
    end
  end

  def new
    redirect_to :accounts if current_user
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
