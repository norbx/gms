# frozen_string_literal: true

class JwtToken
  EXPIRY_DATE = 7.days.from_now.to_i
  SECRET_KEY = Rails.application.secret_key_base

  class << self
    def generate_token(user)
      JWT.encode(payload(user), SECRET_KEY)
    end

    def decode_token(token)
      JWT.decode(token, SECRET_KEY)
    rescue JWT::VerificationError, JWT::ExpiredSignature, JWT::DecodeError
      nil
    end

    private

    def payload(user)
      {
        user_id: user.id,
        exp: EXPIRY_DATE,
        email: user.email,
        iat: Time.now.to_i
      }
    end
  end
end
