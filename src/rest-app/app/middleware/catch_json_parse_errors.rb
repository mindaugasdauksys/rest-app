# rescues from bad json parameters
class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env = nil)
    @app.call(env)
  rescue ActionDispatch::ParamsParser::ParseError => error
    if env['HTTP_ACCEPT'] =~ %r{application/json}
      return [400, { 'Content-Type' => 'application/json' }, []]
    end
    raise error
  end
end
