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
      respond_bad_attributes { render :new }
    end
  end

  def update
    with_id_protected { change_attributes(account_params) { render :edit } }
  end

  def change_attributes(attributes, &block)
    if @account.update_attributes attributes
      puts "redirecting to: #{@account}"
      redirect_to @account
    else
      respond_bad_attributes { block.call }
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

  def transfer
    protect_id
  end

  def new
    @account = Account.new
  end

  def reselect_currency
    begin
      @from_eur = ratio('EUR', 'USD')
      @from_usd = ratio('USD', 'EUR')
      protect_id
    rescue
      render_503
    end
  end

  def convert
    with_id_protected do 
      currency = account_params.require(:currency)
      begin
        change_attributes(amount: @account.amount * ratio(@account.currency,
                                                          currency),
                          currency: currency) { render :reselect_currency }
      rescue
        render_503
      end
    end
  end

  private

  def url(base, symbols)
    "http://api.fixer.io/latest?base=#{base}&symbols=#{symbols}"
  end

  def ratio(base, symbols)
    if !base.eql? symbols
      JSON.parse(RestClient.get(url(base,symbols)).body)['rates'][symbols]
    else
      1
    end
  end

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
