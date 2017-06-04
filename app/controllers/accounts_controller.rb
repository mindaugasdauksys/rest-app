# accounts controller
class AccountsController < ApplicationController
  require 'rest-client'
  require 'currency'
  include AccountsHelper
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_user, only: %i[index show]
  # before_action :authenticate_admin, except: %i[index show]

  def index
    respond_with(@accounts = Account.all)
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
    protect_id
  end

  def convert
    with_id_protected do
      currency = account_params.require(:currency)
      begin
        change_attributes(money: Money.new(new_amount(currency), currency)) do
          render :reselect_currency
        end
      rescue
        render_code 503
      end
    end
  end

  private

  def change_attributes(attributes)
    if @account.update_attributes attributes
      redirect_to @account
    else
      respond_bad_attributes { yield }
    end
  end

  def new_amount(currency)
    @account.amount * Currency.ratio(@account.currency, currency)
  end

  def account_params
    params.fetch(:account, {}).permit(:name, :surname, :amount, :currency)
  end

  def protect_id
    @account = Account.find_by_id(params[:id])
    render_code 404 unless @account
  end

  def with_id_protected
    @account = Account.find_by_id(params[:id])
    @account ? yield : render_code(404)
  end
end
