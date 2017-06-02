# describes transfering money to other bank service
class CarryMoney
  def self.call(payment_params)
    new(payment_params).call
  end

  def initialize(payment_params)
    @payment_params = payment_params
  end

  def call
    begin
      update_in_external
      update_my_account
      @response = 200
      @success = true
    rescue RestClient::Exception => e
      @response = e.http_code
      @success = false
    end
    result
  end

  private

  def update_in_external
    RestClient.patch(address,
                     { 'balance' => new_external_balance }.to_json,
                     content_type: :json,
                     accept: :json) do |response, request, result, &block|
      unless [301, 302, 307].include? response.code
        response.return!(request, result, &block)
      end
    end
  end

  def update_my_account
    acc = Account.find_by_id(@payment_params[:from])
    acc.update(amount: acc.amount - @payment_params[:amount])
  end

  def new_external_balance
    external_balance + @payment_params[:amount]
  end

  def address
    "http://bank_service:8000/accounts/#{@payment_params[:to]}"
  end

  def result
    OpenStruct.new(success?: @success, response: @response)
  end

  def external_balance
    JSON.parse(RestClient.get(address, accept: :json).body)['balance'].to_i
  end
end
