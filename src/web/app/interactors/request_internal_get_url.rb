# requests all get methods
class RequestInternalGetUrl
  def self.call(url)
    new(url).call
  end

  def initialize(url)
    @url = url
  end

  def call
    begin
      @response = RestClient.get @url, accept: :json
      @success = true
    rescue RestClient::Exception => e
      @response = e.http_code
      @success = false
    end
    result
  end

  private

  def result
    OpenStruct.new(success?: @success, response: @response)
  end
end
