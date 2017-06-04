# payments controller
class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    respond_with(@payments = Payment.all)
  end

  def show
    with_id_protected { respond_with @payment }
  end

  def create
    @payment = Payment.new(payment_params)
    if CreatePaymentPolicy.new(@payment).allowed? && @payment.save!
      redirect_to @payment
    else
      respond_bad_attributes { render :new }
    end
  end

  def update
    with_id_protected do
      if @payment.update_attributes(payment_params)
        redirect_to @payment
      else
        respond_bad_attributes { render :edit }
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

  # bank_service - docker image name or might be docker machine ip
  def transfer
    response = RestClient.get 'bank_service:8000/accounts', accept: :json
    @others = if response
                json = JSON.parse(response.body)
                json.map { |entry| entry['id'] }
              else
                []
              end
  end

  def carry
    result = CarryMoney.call(payment_params)
    if result.code == 200
      redirect_to payments_path
    else
      head result.code
    end
  end

  def new
    @payment = Payment.new
  end

  private

  def with_id_protected
    @payment = Payment.find_by_id(params[:id])
    @payment ? yield : render_code(404)
  end

  def payment_params
    params.fetch(:payment, {}).permit(:from, :to, :amount, :currency)
  end
end
