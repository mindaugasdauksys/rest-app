class ApplicationController < ActionController::Base
  protect_from_forgery
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

  def respond_with(param)
    respond_to do |format|
      format.html
      format.json { render json: param }
    end
  end

  def model_name
    params[:controller].classify.constantize
  end
end
