# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate_user
    authenticate_or_request_with_http_token do |token, _options|
      decoded_token = decode_token(token)
      return head :forbidden if decoded_token.nil?

      params = decoded_token[0].with_indifferent_access
      user_exists(params[:email]) && token_not_expired(params[:exp])
    end
  end

  def authenticate_band
    authenticate_or_request_with_http_token do |token, _options|
      decoded_token = decode_token(token)
      return head :forbidden if decoded_token.nil?

      params = decoded_token[0].with_indifferent_access
      band_exists(params[:email]) && token_not_expired(params[:exp])
    end
  end

  private

  def user_exists(user_email)
    User.find_by(email: user_email)
  end

  def band_exists(band_email)
    Band.find_by(email: band_email)
  end

  def token_not_expired(expiration_date)
    expiration_date > Time.zone.now.to_i
  end

  def decode_token(token)
    JwtToken.decode_token(token)
  end
end
