module OmniauthHelper

  def mock_auth_hash(provider, email:)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new(
      'provider' => provider,
      'uid' => '123456',
      'info' => {
        'email' => email
      }
    )
end

  def clean_mock_auth(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = nil
  end

  def failure_mock_auth(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = :invalid_credentials
  end
end
