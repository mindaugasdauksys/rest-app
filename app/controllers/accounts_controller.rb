class AccountsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Account.all
  end

  def create
    @account = Account.create(request.query_parameters)
    render json: @account
  end

  def show
    @account = Account.find_by_id(params[:id])
    render json: @account
  end

  def update
    @account = Account.find_by_id(params[:id])
    @account.update!(request.query_parameters) if @account
    render json: @account
  end

  def destroy
    @account = Account.find_by_id(params[:id])
    @account.destroy if @account
    render json: @account
  end
end
