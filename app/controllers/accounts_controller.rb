class AccountsController < ApplicationController
  require 'rest-client'
  skip_before_action :verify_authenticity_token
  def index
    respond_with (@accounts = Account.all)
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      redirect_to @account
    else
      render :new
    end            
  end

  def show
    with_id_protected(params[:id])
  end

  def update
    with_id_protected(params[:id]) do |account|
      if account.update(account_params)
        redirect_to account
      else
        render :edit
      end
    end
  end

  def edit
    @account = Account.find_by_id(params[:id])
  end

  def new
    @account = Account.new
  end

  def destroy
    with_id_protected(params[:id]) { |account| account.destroy }
    redirect_to accounts_path
  end

  def convert
    with_id_protected(params[:id]) do |acc|
      unless acc.currency.eql? params[:to]
        url = "http://api.fixer.io/latest?base=#{acc.currency}&symbols=#{params[:to]}"
        ratio = JSON.parse(RestClient.get(url).body)['rates'][params[:to]]
        acc.update(amount: acc.amount * ratio, currency: params[:to])
      end
    end
  end

  private

  def account_params
    params.require(:account).permit(:name, :surname, :amount, :currency)
  end

  def with_id_protected(id, &block)
    @account = Account.find_by_id(id)
    if @account
      block.call(@account) if block
      respond_with @account
    else
      render_404
    end
  end
end
