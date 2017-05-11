class ApplicationController < ActionController::Base
  layout proc { current_user ? 'signed_in' : 'application' }
  protect_from_forgery
  rescue_from ActionController::ParameterMissing, with: :render_400

  def require_login
    remember || authenticate_user || render_401
  end

  def current_user
    @current_user ||= (remember || authenticate_user)
  end

  def render_401
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/401", layout: false, status: :unauthorized }
      format.any { head :unauthorized }
    end
  end

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.any { head :not_found }
    end
  end

  def respond_bad_attributes(&block)
    respond_to do |format|
      format.html { block.call }
      format.json { head :bad_request }
    end
  end

  def render_400
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/400", layout: false, status: :bad_request }
      format.any { head :bad_request }
    end
  end

  def render_503
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/503", layout: false, status: 503 }
      format.any { head 503 }
    end
  end

  def respond_with(param)
    respond_to do |format|
      format.html
      format.json { render json: param }
    end
  end

  def model_name
    params[:controller].classify.constantize
  end

  private

  def authenticate_user
    puts 'Authenticating..'
    authenticate_with_http_token do |token, options|
      User.find_by(auth_token: token)
    end
  end

  def remember
    puts 'Trying to remember...'
    puts 'user_id exists' if cookies[:user_id]
    puts 'user exists' if User.find_by_id(cookies.signed[:user_id])
    if (user_id = cookies.signed[:user_id]) && (user = User.find_by_id(user_id)) && (auth_token = user.auth_token)
      puts 'Succeed'
      ActiveSupport::SecurityUtils.secure_compare(
                     ::Digest::SHA256.hexdigest(cookies[:auth_token]),
                     ::Digest::SHA256.hexdigest(auth_token))

      user
    else
      puts 'Failed.'
    end
  end
end
