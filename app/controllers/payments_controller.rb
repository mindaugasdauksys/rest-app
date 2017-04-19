class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    respond_with (@payments = Payment.all)
  end

  def show
    with_id_protected(params[:id])
  end

  def create
    @payment = Payment.new payment_params
    if @payment.save
      respond_with @payment
    else
      render :new
    end
  end

  def update
    with_id_protected(params[:id]) do |payment|
      if payment.update(payment_params)
        redirect_to payment
      else
        render :edit
      end
    end
  end

  def destroy
    with_id_protected(params[:id]) { |payment| payment.destroy }
    redirect_to payments_path
  end

  def edit
    @payment = Payment.find_by_id(params[:id])
  end

  def new
    @payment = Payment.new
  end

  private

  def with_id_protected(id, &block)
    @payment = Payment.find_by_id(id)
    if @payment
      block.call(@payment) if block
      respond_with @payment
    else
      render_404
    end
  end

  def payment_params
    params.require(:payment).permit(:from, :to, :amount, :currency)
  end
end
