class AccountsController < ApplicationController
  require 'rest-client'
  skip_before_action :verify_authenticity_token

  def index
    respond_with (@accounts = Account.all)
  end

  def show
    with_id_protected { respond_with @account }
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to @account
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render_400 }
      end
    end
  end

  def update
    with_id_protected do
      if @account.update_attributes(account_params)
        redirect_to @account
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
      @account.destroy
      redirect_to accounts_path
    end
  end

  def edit
    protect_id
  end

  def new
    @account = Account.new
  end

  def reselect_currency
    to_usd = 'http://api.fixer.io/latest?base=EUR&symbols=USD'
    to_eur = 'http://api.fixer.io/latest?base=USD&symbols=EUR'
    @from_eur = JSON.parse(RestClient.get(to_usd).body)['rates']['USD']
    @from_usd = JSON.parse(RestClient.get(to_eur).body)['rates']['EUR']
    protect_id
  end

  def get_currency(url)
    JSON.parse(RestClient.get(url).body)
  end

  def convert
    currency = account_params[:currency]
    with_id_protected do
      unless @account.currency.eql? currency
        url = "http://api.fixer.io/latest?base=#{@account.currency}&symbols=#{currency}"
        ratio = JSON.parse(RestClient.get(url).body)['rates'][currency]
        @account.update(amount: @account.amount * ratio, currency: currency)
      end
      redirect_to account_path
    end
  end

  private

  def account_params
    params.fetch(:account, {}).permit(:name, :surname, :amount, :currency)
  end

  def protect_id
    @account = Account.find_by_id(params[:id])
    render_404 unless @account
  end

  def with_id_protected(&block)
    @account = Account.find_by_id(params[:id])
    @account ? block.call : render_404
  end
end
