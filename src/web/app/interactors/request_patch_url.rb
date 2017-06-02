# requests patch url
class RequestPatchUrl
  def self.call(url, patch_params)
    new(url, patch_params).call
  end

  def initialize(url, patch_params)
    @patch_params = patch_params
    @url = url
  end

  def call
    begin
      send_patch
      @response = RequestInternalGetUrl.call(@final_url).response
      @success = true
    rescue RestClient::Exception => e
      @response = e.http_code
      @success = false
    end
    result
  end

  private

  def send_patch
    RestClient.patch @url,
                     @patch_params.to_json,
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
    OpenStruct.new(success?: @success, response: @response)
  end
end
