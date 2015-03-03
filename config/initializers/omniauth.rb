require 'omniauth-siso'
require File.expand_path('../../omniauth', __FILE__)

Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = SISO_PREFIX
  end
  provider :siso, SISO_APP_ID, SISO_SECRET, :client_options => {
    site: SISO_SITE,
    authorize_url: SISO_AUTHORIZE_URL,
    token_url: SISO_TOKEN_URL
  }
end
