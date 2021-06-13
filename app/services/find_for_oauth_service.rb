class FindForOauthService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
    # authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid)
    return authorization.user if authorization

    email_auth
    user = User.where(email: email_auth).first
    # user = User.find_by(email: email_auth)
    if user
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
      user
    else
      create_user!(auth)
    end
  end

  def email_auth
    email = if auth.info[:email].blank?
              "uid_#{auth.uid}@#{auth.provider.downcase}.com"
            else
              auth.info[:email]
            end
  end

  private

  def create_user!(auth)
    password = Devise.friendly_token[0, 20]

    if email_auth.include?('uid_')
      user = User.new(email: email_auth, password: password, password_confirmation: password)
      user.skip_confirmation_notification!
      user.save
    else
      user = User.create!(email: email_auth, password: password, password_confirmation: password)
    end

    Authorization.transaction do
      user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    end
    user
  end
end
