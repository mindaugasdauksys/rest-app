class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env=nil)
    begin
      @app.call(env)
    rescue ActionDispatch::ParamsParser::ParseError => error
      if env['HTTP_ACCEPT'] =~ /application\/json/
        return [ 400, { 'Content-Type' => 'application/json' }, [] ]
      else
        raise error
      end
    end
  end
end
