# frozen_string_literal: true

class JwtToken
  EXPIRY_DAYS = ENV['TOKEN_EXPIRY_DATE'] || 7
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
        exp: EXPIRY_DAYS.to_i.days.from_now.to_i,
        email: user.email,
        iat: Time.now.to_i
      }
    end
  end
end
