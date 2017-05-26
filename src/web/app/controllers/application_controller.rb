class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from ActionController::ParameterMissing, with: :render_400

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
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
  
  protected

  def send_get(url)
    begin
      response = RestClient.get url, {accept: :json}
    rescue RestClient::ExceptionWithResponse => e
      render nothing: true, status: e.split.first.to_i
      return
    end
    render json: response, status: response.code
  end

  def authenticate_request!
    if !payload || !JsonWebToken.valid_payload(payload.first)
      puts 'first'
      puts 'payload' if !payload
      puts 'invalid payload' if payload
      head :unauthorized
    else
      load_current_user!
      puts 'second' unless @current_user
      head :unauthorized unless @current_user
    end
  end

  def authenticate_admin!
    puts "payload[1]: #{payload[0].to_json}"
    if !payload || !JsonWebToken.valid_payload(payload.first) || payload[0]['mode'] != 'admin'
      puts 'first'
      puts 'payload' if !payload
      puts 'invalid payload' if payload
      head :unauthorized
    else
      load_current_user!
      puts 'second' unless @current_user
      head :unauthorized unless @current_user
    end
  end
  private

  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  rescue
    puts 'payload rescue'
    nil
  end

  def load_current_user!
    @current_user = User.find_by(id: payload[0]['user_id'])
  end
end

require 'json_web_token'
