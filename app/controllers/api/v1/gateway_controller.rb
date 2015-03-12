class Api::V1::GatewayController < Api::ApiController

  # GET /s/:service_name/*path
  def get
    if @service = @client.services.find_by_name(params[:service_name])
      conn = Faraday.new(url: @service.base_url,
                         ssl: {verify: false}) do |faraday|
        faraday.adapter Faraday.default_adapter
      end
      @result = set_result conn.get params[:path] + '.json'
      gateway_log('<%s>/%s served with %s' % [@service.name,
                                              params[:path],
                                              @result[:status]],
                  @result[:extra])
    else
      @result = set_error 404, 'Not Found'
      gateway_log('no service found for client', @result[:extra])
    end
  end

  # POST /s/:service_name/*path
  def post
    render_unauthorized
  end

  # PUT /s/:service_name/*path
  def put
    render_unauthorized
  end

  # DELETE /s/:service_name/*path
  def delete
    render_unauthorized
  end

  private
  def set_result response
    {
      service: params[:service_name],
      status: response.env.status,
      response: JSON.parse(response.body),
      extra: {
        base_url: @service.base_url,
        path: params[:path],
        url: response.env.url.to_s,
        method: response.env.method.upcase,
        headers: response.env.response_headers,
      }
    }
  end

  def set_error status, reason
    {
      service: params[:service_name],
      status: status,
      response: nil,
      extra: {
        path: params[:path],
        message: reason,
      }
    }
  end
end
# vim: set ts=2 sw=2 expandtab:
