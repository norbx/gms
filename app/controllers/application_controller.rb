# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  def authenticate
    authenticate_or_request_with_http_token do |token, _options|
      @token = token
      return head :forbidden unless user_valid?

      current_user
    end
  end

  def current_user
    return unless decoded_token.present?

    @current_user ||= User.find(user_token[:user_id])
  end

  private

  attr_reader :token

  def user_valid?
    decoded_token.present? && current_user.present? && token_not_expired(user_token[:exp])
  end

  def token_not_expired(expiration_date)
    expiration_date > Time.zone.now.to_i
  end

  def user_token
    @decoded_token[0].with_indifferent_access
  end

  def decoded_token
    @decoded_token ||= JwtToken.decode_token(token)
  end
end
