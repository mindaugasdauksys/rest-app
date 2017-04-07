class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Payment.all
  end

  def show 
    render json: Payment.find_by_id(params[:id])
  end

  def create
    puts request.query_parameters
    @payment = Payment.create(request.query_parameters)
    render json: @payment
  end
end
