class AccountsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Account.all
  end

  def create
    @account = Account.new
    @account.name = params[:name]
    @account.surname = params[:surname]
    @account.money = params[:money]
    @account.save
    render json: Account.all
  end

  def show
    render json: Account.find(params[:id])
  end

  def update 
    @account = Account.find(params[:id])
    @account.name = params[:name]
    @account.surname = params[:surname]
    @account.money = params[:money]
    @account.save
    render json: @account
  end
end
