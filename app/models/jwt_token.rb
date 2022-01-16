# frozen_string_literal: true

class JwtToken
  EXPIRY_DATE = 7.days.from_now.to_i
  SECRET_KEY = Rails.application.secrets.secret_key_base

  class << self
    def generate_token(user)
      JWT.encode(payload(user), SECRET_KEY)
    end

    def decode_token(token)
      JWT.decode(token, SECRET_KEY)[0].with_indifferent_access
    end

    private

    def payload(user)
      {
        exp: EXPIRY_DATE,
        email: user.email,
        iat: Time.now.to_i
      }
    end
  end
end
