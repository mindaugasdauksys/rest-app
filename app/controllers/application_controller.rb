require 'json_web_token'

# abstract controller
class ApplicationController < ActionController::Base
  protect_from_forgery
  rescue_from ActionController::ParameterMissing, with: -> { render_code 400 }

  def respond_bad_attributes
    respond_to do |format|
      format.html { yield }
      format.json { head :bad_request }
    end
  end

  def render_not_found
    render_code 404
  end

  def render_code(code)
    respond_to do |format|
      format.html { render_file_with_code code }
      format.any { head code }
    end
  end

  def respond_with(param)
    respond_to do |format|
      format.html
      format.json { render json: param }
    end
  end

  protected

  def authenticate_user
    load_current_user if auth_policy.at_least_user?
    head :unauthorized unless @current_user
  end

  def authenticate_admin
    if auth_policy.user?
      head :forbidden
    else
      load_current_user if auth_policy.admin?
      head :unauthorized unless @current_user
    end
  end

  def auth_policy
    AuthorizationPolicy.new(payload)
  end

  private

  def payload
    return unless (auth_header = request.headers['Authorization'])
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  end

  def load_current_user
    @current_user = User.find_by(id: payload[0]['user_id'])
  end

  def render_file_with_code(code)
    render file: "#{Rails.root}/public/#{code}", layout: false, status: code
  end
end
