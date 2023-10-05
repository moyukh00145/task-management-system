# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.credentials.dig(:google_auth, :id),
           Rails.application.credentials.dig(:google_auth, :secret)
end
# OmniAuth.config.allowed_request_methods = %i[get]
# OmniAuth.config.allowed_request_methods = [:post, :get]'

# For signout from google access token hit this url with the token https://accounts.google.com/o/oauth2/revoke?token=s
