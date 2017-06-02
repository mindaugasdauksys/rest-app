# requests all get methods
class RequestInternalGetController
  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @id = params[:id]
    @controller = params[:controller]
  end

  def call
    RequestInternalGetUrl.call(url)
  end

  private

  def url
    "http://rest_app:3001/#{@controller}/#{@id}"
  end
end
