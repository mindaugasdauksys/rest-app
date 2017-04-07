class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Payment.all
  end

  def show 
    @payment = Payment.find_by_id(params[:id])
    if @payment
      render json: @payment
    else
      render_404
    end 
  end

  def create
    if params[:from] and params[:to] and params[:amount]
      @payment = Payment.create(request.query_parameters)
    else
      @payment = nil
    end
    render json: @payment
  end
end
