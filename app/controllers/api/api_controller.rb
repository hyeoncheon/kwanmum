class Api::ApiController < ActionController::Base
  before_action :token_required

  def api_log(level, how, what, message, why='', tags='')
    category = 'api'
    now = Time.now
    where = env['HTTP_X_FORWARDED_FOR']
    process = env['HTTP_USER_AGENT']
    if @client
      who = @client.name
      @client.logs.create(
        category: category, level: level, time: now, service: 'kwanmun',
        process: process, message: message, hostname: where,
        actor: who, action: how, target: what, reason: why, tag: tags)
    else
      Log.create(
        category: category, level: 'error', time: now, service: 'kwanmun',
        process: process, message: message, hostname: where,
        actor: 'Bug', action: how, target: what, reason: why, tag: tags)
      puts "ERROR"
    end
  end

  protected
  def token_required
    client_addr = env['HTTP_X_FORWARDED_FOR']
    unless @client = Server.find_by_address(client_addr)
      @client = Server.create(address: client_addr)
      api_log('info', 'server#create', @client.id, '', 'first request')
    end

    if authenticate_token
      api_log('info', 'authenticated', @client.id, '', 'valid token')
    else
      api_log('info', 'authentication failed', @client.id, '', 'invalid token')
      render_unauthorized
    end
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @client.is_authorized?(token)
    end
  end

  def render_unauthorized
    self.headers['WWW-Authenticate'] = 'Token realm="Kwanmun"'
    render json: error(401, :unauthorized), status: :unauthorized
  end

  def error code, reason
    parameters = params
    parameters.delete(:format)
    parameters.delete(:controller)
    parameters.delete(:action)

    {
      error: code,
      reason: reason,
      request: {
        uri: env['REQUEST_URI'],
        params: parameters
      }
    }
  end
end
# vim: set ts=2 sw=2 expandtab:
