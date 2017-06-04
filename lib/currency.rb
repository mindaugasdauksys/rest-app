# used to get currencies
class Currency
  def self.ratio(from, to)
    if !from.eql? to
      JSON.parse(RestClient.get("http://api.fixer.io/latest?base=#{from}")
                           .body)['rates'][to]
    else
      1
    end
  end
end
