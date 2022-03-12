# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BandSessionsController, type: :request do
  describe 'POST /create' do
    subject(:request) { post '/bands/sign_in', params: params }

    let(:band) { create(:band, email: 'test@mail.com', password: 'password') }

    let(:params) do
      {
        band: {
          email: 'test@mail.com',
          password: 'password'
        }
      }
    end

    before { band }

    it 'returns a token and a status 200' do
      request

      expect(response).to have_http_status(200)
      expect(json_response).to have_key(:token)
    end

    context 'when credentials are invalid' do
      before { params[:band][:password] = 'invalid' }

      it 'returns status 403' do
        request

        expect(response).to have_http_status(403)
      end
    end
  end
end
