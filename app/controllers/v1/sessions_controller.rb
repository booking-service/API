module V1
  class SessionsController < ApplicationController
    skip_before_action :authenticate_merchant_from_token!

    # POST /v1/login
    def create
      @merchant = Merchant.find_for_database_authentication(email: params[:username])
      return invalid_login_attempt unless @merchant

      if @merchant.valid_password?(params[:password])
        sign_in :merchant, @merchant
        render json: @merchant, serializer: SessionSerializer, root: nil
      else
        invalid_login_attempt
      end
    end

    private

    def invalid_login_attempt
      warden.custom_failure!
      render json: {error: t('sessions_controller.invalid_login_attempt')}, status: :unprocessable_entity
    end

  end
end
