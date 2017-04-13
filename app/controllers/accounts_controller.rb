class AccountsController < ApplicationController
  require 'rest-client'
  skip_before_action :verify_authenticity_token
  def index
    render json: Account.all
  end

  def create
    render json: Account.create(params.permit(:name, :surname, :amount, :currency))
  end

  def show
    with_id_protected(params[:id])
  end

  def update
    with_id_protected(params[:id]) do |account|
      account.update(params.permit(:name, :surname, :amount, :currency))
    end
  end

  def destroy
    with_id_protected(params[:id]) { |account| account.destroy }
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

  def with_id_protected(id, &block)
    @account = Account.find_by_id(id)
    if @account
      block.call(@account) if block
      render json: @account
    else
      render_404
    end
  end
end
