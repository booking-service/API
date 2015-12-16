module V1
  class SessionSerializer < ActiveModel::Serializer

    attributes :email, :token_type, :merchant_id, :access_token

    def merchant_id
      object.id
    end

    def token_type
      'Bearer'
    end

  end
end
