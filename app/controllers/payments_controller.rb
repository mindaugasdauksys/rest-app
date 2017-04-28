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
      respond_bad_attributes { render :new }
    end
  end

  def update
    with_id_protected do
      if @payment.update_attributes(payment_params)
        redirect_to @payment
      else
        respond_bad_attributes{ render :edit }
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
    address = "172.17.0.1:8000/accounts"
    begin
      response = RestClient.get address, {accept: :json}
    rescue Exception => e
      puts "EXCEPTION CAUGHT: #{e}"
    end
      
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
    address = "172.17.0.1:8000/accounts/#{payment_params[:to]}"
    puts address
    response = RestClient.get(address, {accept: :json})
    if response.code == 200
      puts JSON.parse response.body
      balance = JSON.parse(response.body)['balance'].to_i
      begin
        RestClient.patch(address, {'balance' => balance + payment_params[:amount].to_i}.to_json, {content_type: :json, accept: :json}) 
      rescue Exception => e
        puts "EXCEPTION: #{e}"
      end
      puts "TRANSFERED: #{balance} + #{payment_params[:amount]}"
      redirect_to payments_path
    else
      puts response.code
      render_400
    end
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
