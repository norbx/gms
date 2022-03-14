# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BandsController, type: :request do
  describe 'GET /bands' do
    subject { get '/bands' }

    let(:band) { create(:band) }

    before { band }

    it 'returns a band and status 200' do
      subject

      expect(response).to have_http_status(200)
      expect(json_response['bands']).to be_an(Array)
      expect(json_response['bands'][0]['id']).to be_present
      expect(json_response['bands'][0]['name']).to be_present
      expect(json_response['bands'][0]['contact_name']).to be_present
      expect(json_response['bands'][0]['phone_number']).to be_present
      expect(json_response['bands'][0]['description']).to be_present
      expect(json_response['bands'][0]['social_links']).to be_present
    end
  end

  describe 'GET /bands/:id' do
    subject { get "/bands/#{band.id}" }

    let(:band) { create(:band) }

    it 'returns a band and status 200' do
      subject

      expect(response).to have_http_status(200)
      expect(json_response['band']).to be_a(Hash)
      expect(json_response['band']['id']).to be_present
      expect(json_response['band']['name']).to be_present
      expect(json_response['band']['contact_name']).to be_present
      expect(json_response['band']['phone_number']).to be_present
      expect(json_response['band']['description']).to be_present
      expect(json_response['band']['social_links']).to be_present
    end
  end

  describe 'POST /bands' do
    subject(:request) { post '/bands', params: params }

    let(:params) do
      {
        band: {
          name: 'test',
          first_name: 'test',
          last_name: 'test'
        }
      }
    end

    it 'creates a band and returns successful response' do
      expect { request }.to change(Band, :count).by(1)
      expect(response).to have_http_status(201)
      expect(json_response).to be_a(Hash)
    end

    context 'with blank name' do
      before { params[:band][:name] = '' }

      it 'creates no band and returns error response' do
        expect { request }.not_to change(Band, :count)
        expect(response).to have_http_status(422)
        expect(response.body).to include('Name can\'t be blank')
      end
    end
  end

  describe 'PUT /bands/:id' do
    subject { put "/bands/#{band.id}", params: params, headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:user) { create(:user) }
    let(:band) { create(:band, name: 'the stonks', phone_number: nil) }
    let(:params) { { band: { phone_number: '+1 0203 044 11' } } }

    it 'updates attribute' do
      expect { subject }.to change { band.reload.phone_number }.from(nil).to(params[:band][:phone_number])
    end

    context 'with invalid authorization token' do
      let(:headers) { { HTTP_AUTHORIZATION: 'Token some_random_token' } }

      it 'returns 403' do
        subject

        expect(response).to have_http_status(403)
      end
    end
  end
end
