# requests patch url
class RequestPatchUrl
  attr_reader :code, :response, :final_url

  def self.call(url, patch_params)
    new(url, patch_params).call
  end

  def initialize(url, patch_params)
    @patch_params = patch_params
    @url = url
  end

  def call
    begin
      @response = request_page.response
      @code = response.code
    rescue RestClient::Exception => req_exception
      @code = req_exception.http_code
    end
    result
  end

  private

  def request_page
    send_patch
    RequestInternalGetUrl.call(final_url)
  end

  def send_patch
    RestClient.patch @url, @patch_params.to_json,
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

  def result
    OpenStruct.new(code: code, response: response)
  end
end
