class ApplicationController < ActionController::Base
  protect_from_forgery

  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404", layout: false, status: :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  def render_400
    respond_to do |format|
      format.html { render file "#{Rails.root}/public/400", layout: false, status: :bad_request }
      format.any { head :bad_request }
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
