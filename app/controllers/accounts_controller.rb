class AccountsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    render json: Account.all
  end

  def create
    if params[:name] and params[:surname] and params[:money]
      @account = Account.create(request.query_parameters)
    else
      @account = nil
    end
    render json: @account
  end

  def show
    @account = Account.find_by_id(params[:id])
    render json: @account if @account
    render_404 unless @account
  end

  def update
    @account = Account.find_by_id(params[:id])
    if @account
      @account.update!(request.query_parameters)
      render json: @account
    else
      render_404
    end
  end

  def destroy
    @account = Account.find_by_id(params[:id])
    if @account
      @account.destroy
      render json: @account
    else
      render_404
    end
  end
end
