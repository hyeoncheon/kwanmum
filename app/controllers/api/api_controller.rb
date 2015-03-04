class Api::ApiController < ActionController::Base
  before_action :token_required

  def token_required
    client_addr = env['HTTP_X_FORWARDED_FOR']
    unless @client = Server.find_by_address(client_addr)
      @client = Server.create(address: client_addr)
    end

    authenticate_or_request_with_http_token do |token, options|
      @client.is_authorized?(token)
    end
  end
end
# vim: set ts=2 sw=2 expandtab:
