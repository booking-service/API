class ApplicationController < ActionController::API
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  include AbstractController::Translation

  before_action :authenticate_merchant_from_token!

  respond_to :json

  ##
  # merchant Authentication
  # Authenticates the merchant with OAuth2 Resource Owner Password Credentials Grant
  def authenticate_merchant_from_token!
    auth_token = request.headers['Authorization']

    if auth_token
      authenticate_with_auth_token auth_token
    else
      authentication_error
    end
  end

  private

  def authenticate_with_auth_token auth_token
    unless auth_token.include?(':')
      authentication_error
      return
    end

    merchant_id = auth_token.split(':').first
    merchant = Merchant.where(id: merchant_id).first

    if merchant && Devise.secure_compare(merchant.access_token, auth_token)
      # merchant can access
      sign_in merchant, store: false
    else
      authentication_error
    end
  end

  ##
  # Authentication Failure
  # Renders a 401 error
  def authentication_error
    # merchant's token is either invalid or not in the right format
    render json: {error: t('unauthorized')}, status: 401  # Authentication timeout
  end
end
