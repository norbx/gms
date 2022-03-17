# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserSessionsController, type: :request do
  describe 'POST /create' do
    subject(:request) { post '/users/sign_in', params: params }

    let(:user) { create(:user, email: 'test@mail.com', password: 'password') }

    let(:params) do
      {
        user: {
          email: 'test@mail.com',
          password: 'password'
        }
      }
    end

    before { user }

    it 'returns a token and a status 200' do
      request

      expect(response).to have_http_status(200)
      expect(json_response).to have_key(:token)
      expect(json_response).to have_key(:user)
      expect(json_response['user']).to be_a(Hash)
      expect(json_response['user']['id']).to be_present
      expect(json_response['user']['email']).to be_present
      expect(json_response['user']['name']).to be_present
      expect(json_response['user']['first_name']).to be_present
      expect(json_response['user']['last_name']).to be_present
      expect(json_response['user']['password']).not_to be_present
      expect(json_response['user']['password_digest']).not_to be_present
    end

    context 'when credentials are invalid' do
      before { params[:user][:password] = 'invalid' }

      it 'returns status 403' do
        request

        expect(response).to have_http_status(403)
      end
    end
  end
end
