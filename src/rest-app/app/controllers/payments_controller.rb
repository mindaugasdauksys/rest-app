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
    params.each { |key, value| puts "#{key}:#{value}" }
    @payment = Payment.new(payment_params)
    if @payment.save!
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

  def transfer
    @payment = Payment.new
    @accounts = Account.ids.map(&:to_s)
    response = RestClient.get 'bank_service:8000/accounts', accept: :json
    @others = if response
                json = JSON.parse(response.body)
                json.map { |entry| entry['id'] }
              else
                []
              end
  end

  def edit
    with_id_protected {}
  end

  def new
    @payment = Payment.new
  end

  def carry
    result = CarryMoney.call(payment_params)
    if result.success?
      redirect_to payments_path
    else
      head result.response
    end
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
