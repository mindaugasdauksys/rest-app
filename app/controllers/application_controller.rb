class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActionController::RoutingError, :with => :error_render_method

  def error_render_method
    respond_to do |type|
      type.xml { render :template => "errors/error_404", :status => 404 }
      type.all  { render :nothing => true, :status => 404 }
    end
    render :nothing => true, :status => 404
    true
  end
end
