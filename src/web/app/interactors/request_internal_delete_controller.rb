# requests all post methods
class RequestInternalDeleteController
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @controller = params[:controller]
    @id = params[:id]
  end

  def call
    begin
      send_delete
      @response = RequestInternalGetUrl.call(@final_url).response
      @success = true
    rescue RestClient::Exception => e
      @response = e.http_code
      @success = false
    end
    result
  end

  private

  def send_delete
    RestClient.delete url,
                      content_type: :json,
                      accept: :json do |response, request, _, &block|
      if [301, 302, 307].include? response.code
        @final_url = response.headers[:location]
      else
        @final_url = request.url
        response.return!(&block)
      end
    end
  end

  def url
    "http://rest_app:3001/#{@controller}/#{@id}"
  end

  def result
    OpenStruct.new(success?: @success, response: @response)
  end
end
