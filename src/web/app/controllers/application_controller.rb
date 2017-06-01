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
    result = RequestInternalPostController.call(params)
    if result.success?
      render json: result.response
    else
      head result.response
    end
  end

  def update
    result = RequestInternalPatchController.call(params)
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
    result = RequestInternalDeleteController.call(params)
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

  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload.first)
      head :unauthorized
    else
      load_current_user!
      head :unauthorized unless @current_user
    end
  end

  def authenticate_admin!
    if !payload || !JsonWebToken.valid_payload(payload.first) ||
       payload[0]['mode'] != 'admin'
      head :unauthorized
    else
      load_current_user!
      head :unauthorized unless @current_user
    end
  end

  private

  def send_get
    result = RequestInternalGetController.call(params)
    if result.success?
      render json: result.response
    else
      head result.response
    end
  end

  def render_file_with_code(code)
    render file: "#{Rails.root}/public/#{code}", layout: false, status: code
  end

  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  end

  def load_current_user!
    @current_user = User.find_by(id: payload[0]['user_id'])
  end
end

require 'json_web_token'
