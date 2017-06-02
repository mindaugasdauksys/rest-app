# requests all post methods
class RequestInternalPostController
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    puts "got params #{params.to_json}"
    @controller = params[:controller]
    @post_params = params.fetch(post_params, {})
    puts "controller #{@controller}"
    puts "params #{@post_params.to_json}"
  end

  def call
    begin
      send_post
      @response = RequestInternalGetUrl.call(@final_url).response
      @success = true
    rescue RestClient::Exception => e
      @response = e.http_code
      @success = false
    end
    result
  end

  private

  def send_post
    RestClient.post url,
                    @post_params.to_json,
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

  def post_params
    @controller.singularize.to_sym
  end

  def url
    "http://rest_app:3001/#{@controller}"
  end

  def result
    OpenStruct.new(success?: @success, response: @response)
  end
end
