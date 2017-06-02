# abstract controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from ActionController::ParameterMissing, with: -> { render_code 400 }

  def index
    send_get
  end

  def show
    send_get
  end

  def create
    result = RequestInternalPostController.call(post_params)
    if result.success?
      render json: result.response
    else
      head result.response
    end
  end

  def update
    result = RequestInternalPatchController.call(patch_params)
    if result.success?
      render json: result.response
    else
      head result.response
    end
  end

  def render_404
    render_code 404
  end

  def destroy
    result = RequestInternalDeleteController.call(identity_params)
    if result.success?
      render json: result.response
    else
      head result.response
    end
  end

  protected

  def render_code(code)
    respond_to do |format|
      format.html { render_file_with_code code }
      format.any { head code }
    end
  end

  def respond_bad_attributes
    respond_to do |format|
      format.html { yield }
      format.json { head :bad_request }
    end
  end

  def authenticate_user!
    if auth_policy.at_least_user?
      load_current_user!
      head :unauthorized unless @current_user
    else
      head :unauthorized
    end
  end

  def authenticate_admin!
    if auth_policy.admin?
      load_current_user!
      head :unauthorized unless @current_user
    elsif auth_policy.at_least_user?
      head :forbidden
    else
      head :unauthorized
    end
  end

  def auth_policy
    AuthorizationPolicy.new(payload)
  end

  private

  def send_get
    result = RequestInternalGetController.call(identity_params)
    if result.success?
      render json: result.response
    else
      head result.response
    end
  end

  def render_file_with_code(code)
    render file: "#{Rails.root}/public/#{code}", layout: false, status: code
  end

  def post_params
    params.slice('controller', controller_name.singularize)
  end

  def patch_params
    params.slice('controller', controller_name.singularize, 'id')
  end

  def identity_params
    params.slice('controller', 'id')
  end

  def payload
    return unless (auth_header = request.headers['Authorization'])
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  end

  def load_current_user!
    @current_user = User.find_by(id: payload[0]['user_id'])
  end
end

require 'json_web_token'
