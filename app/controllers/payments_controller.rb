class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    respond_with (@payments = Payment.all)
  end

  def show
    with_id_protected { respond_with @payment }
  end

  def create
    @payment = Payment.new(payment_params)
    if @payment.save
      redirect_to @payment
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render_400 }
      end
    end
  end

  def update
    with_id_protected do
      if @payment.update_attributes(payment_params)
        redirect_to @payment
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render_400 }
        end
      end
    end
  end

  def destroy
    with_id_protected do
      @payment.destroy
      redirect_to payments_path
    end
  end

  def edit
    with_id_protected {}
  end

  def new
    @payment = Payment.new
  end

  private

  def with_id_protected(&block)
    @payment = Payment.find_by_id(params[:id])
    @payment ? block.call : render_404
  end

  def payment_params
    params.fetch(:payment, {}).permit(:from, :to, :amount, :currency)
  end
end
