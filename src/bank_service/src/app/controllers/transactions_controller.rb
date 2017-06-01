class TransactionsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  skip_before_action :verify_authenticity_token

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction
    else
      render 'new'
    end
  end

  def show
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @transaction }
    end
  end

  def index
    @transactions = []
    if (params.has_key?(:first_name))
      # Find accounts
      accounts = Account.where('lower(first_name) LIKE ?', "%#{params['first_name'].downcase}%")

      # Extract ids
      ids = accounts.map(&:id)

      # Find transactions
      @transactions = Transaction.where('recipient_id IN (?)', ids).or(Transaction.where('sender_id IN (?)', ids))
    else
      @transactions = Transaction.all
    end

    respond_to do |format|
      format.json { render json: @transactions }
      # format.html
    end

  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])

    if @transaction.update(transaction_params)
      redirect_to @transaction
    else
      render 'edit'
    end
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    redirect_to transactions_path
  end

  def sender
    @transactions = Transaction.where(sender_id: params[:id])
    puts @transactions.size
    render 'index'
  end

  def recipient
    @transactions = Transaction.where(recipient_id: params[:id])
    render 'index'
  end

  def account
    @transactions = Transaction.where(recipient_id: params[:id]).or(Transaction.where(sender_id: params[:id]))
    render 'index'
  end

  def amount
    @transaction = Transaction.find(params[:id])
    # Default amount and currency
    @amount = @transaction.amount
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
      @amount *= rate;
      @currency = params[:currency]
    rescue Exception => e
      puts "Whoops caught: #{e}..."
    end

    respond_to do |format|
      format.html
      format.json { render json: { amount: @amount, currency: @currency } }
    end
  end

  private
    def transaction_params
      params.require(:transaction).permit(:sender_id, :recipient_id, :amount)
    end

    def not_found(error)
      respond_to do |format|
        format.html { render 'errors/404' , status: 404 }
        format.json { render json: { error: error.message }, status: :not_found }
      end
    end
end
