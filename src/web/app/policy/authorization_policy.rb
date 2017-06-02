# authorization policy
class AuthorizationPolicy
  def initialize(payload)
    @payload = payload
  end

  def admin?
    good_payload? && mode.eql?('admin')
  end

  def at_least_user?
    good_payload?
  end

  private

  def good_payload?
    @payload && valid_payload?
  end

  def payload
    return unless @payload
    JsonWebToken.decode(@payload)
  end

  def valid_payload?
    JsonWebToken.valid_payload(@payload.first)
  end

  def mode
    @payload[0]['mode']
  end
end
