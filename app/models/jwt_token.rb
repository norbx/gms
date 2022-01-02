# frozen_string_literal: true

class JwtToken
  EXPIRE_DATE = 7.days.from_now.to_i
  SECRET_KEY = Rails.application.secrets.secret_key_base

  class << self
    def generate_token(user)
      JWT.encode(payload(user), SECRET_KEY)
    end

    def decode_token(token)
      JWT.decode(token)
    end

    private

    def payload(user)
      {
        exp: EXPIRE_DATE,
        username: user.username
      }
    end
  end
end
