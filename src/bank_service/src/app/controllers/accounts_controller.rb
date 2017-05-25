class AccountsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)

    if @account.save
      redirect_to @account
    else
      render 'new'
    end
  end

  def show
    @account = Account.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @account }
    end
  end

  def index
    if (params.has_key?(:first_name))
      @accounts = Account.where('lower(first_name) LIKE ?', "%#{params['first_name'].downcase}%")
    else
      @accounts = Account.all
    end

    respond_to do |format|
      format.html
      format.json { render json: @accounts }
    end
  end

  def edit
    @account = Account.find(params[:id])
  end

  def update
    @account = Account.find(params[:id])

    if @account.update(account_params)
      redirect_to @account
    else
      render 'edit'
    end
  end

  def destroy
    @account = Account.find(params[:id])
    @account.destroy

    redirect_to accounts_path
  end

  def balance
    @account = Account.find(params[:id])
    # Default balance and currency
    @balance = @account.balance
    @currency = 'EUR'

    begin
      # Convert currency to uppercase
      params[:currency].upcase!

      # Call API
      url = "http://api.fixer.io/latest?symbols=#{params[:currency]}"
      response = HTTParty.get(url, format: :json)
      puts "API responded with: #{response}"
      payload = response.parsed_response

      # Parse response
      rates = payload['rates']
      rate = rates[params[:currency]]
      @balance *= rate;
      @currency = params[:currency]
    rescue Exception => e
      puts "Whoops caught: #{e}..."
    end

    respond_to do |format|
      format.html
      format.json { render json: { balance: @balance, currency: @currency } }
    end
  end

  private
    def account_params
      params.require(:account).permit(:first_name, :last_name, :balance)
    end

    def not_found(error)
      respond_to do |format|
        format.html { render 'errors/404' , status: 404 }
        format.json { render json: { error: error.message }, status: :not_found }
      end
    end
end
