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

  def render_404
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

  private def render_file_with_code(code)
    render file: "#{Rails.root}/public/#{code}", layout: false, status: code
  end
end
