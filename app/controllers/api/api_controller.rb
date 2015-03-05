class Api::ApiController < ActionController::Base
  before_action :token_required
  after_action :service_log

  def log(category, level, tm, process, message, where, how, what, why, tags)
    if @client
      @client.logs.create(
        category: category, level: level, time: tm, service: :kwanmun,
        process: process, message: message, hostname: where,
        actor: :api, action: how, target: what, reason: why, tag: tags)
    else
      sys = Server.find_by_address('127.0.0.1')
      sys.logs.create(
        category: category, level: :error, time: tm, service: :kwanmun,
        process: process, message: message, hostname: where,
        actor: :bug, action: how, target: what, reason: why, tag: tags)
    end
  end

  def api_log(level, action, target, mesg=nil, why=nil, tags=nil)
    category = 'api'
    now = Time.now
    where = env['HTTP_X_FORWARDED_FOR']
    process = env['HTTP_USER_AGENT']
    log(category, level, now, process, mesg, where, action, target, why, tags)
  end

  def service_log(mesg=nil, why=nil, tags=nil)
    category = 'api'
    level = 'info'
    action = env['REQUEST_METHOD'] + ' ' + env['PATH_INFO']
    target = env['QUERY_STRING']
    now = Time.now
    where = env['HTTP_X_FORWARDED_FOR']
    process = env['HTTP_USER_AGENT']
    log(category, level, now, process, mesg, where, action, target, why, tags)
  end

  protected
  def token_required
    client_addr = env['HTTP_X_FORWARDED_FOR']
    unless @client = Server.find_by_address(client_addr)
      @client = Server.create(address: client_addr)
      api_log(:info, 'server#create', @client.id, 'register', 'first request')
    end

    if authenticate_token
      api_log(:debug, 'authenticate', @client.id, 'valid authentication.')
    else
      api_log(:error, 'authenticate', @client.id, 'invalid authentication.')
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
        method: request.method,
        params: parameters
      }
    }
  end
end
# vim: set ts=2 sw=2 expandtab:
