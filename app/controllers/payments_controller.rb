class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Payment.all
  end

  def show 
    render json: Payment.find(params[:id])
  end

  def create
    @payment = Payment.new
    @payment.from = params[:to]
    @payment.to = params[:to]
    @payment.amount = params[:amount]
    @payment.save
    render json: @payment
  end
end
