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

  describe 'GET /users/:id/bands' do
    subject { get "/users/#{user.id}/bands", headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:user) { create(:user) }
    let(:band1) { create(:band, name: 'The stonks') }
    let(:band2) { create(:band, name: 'The kicks') }

    before do
      user.bands << band1
      user.bands << band2
    end

    it 'returns a list of user bands' do
      subject

      expect(response).to have_http_status(200)
      expect(json_response[:bands]).to be_an(Array)
      expect(json_response[:bands].size).to eq(2)
      expect(json_response[:bands].first['name']).to eq(band1.name)
      expect(json_response[:bands].second['name']).to eq(band2.name)
    end

    context 'with bands belonging to different user' do
      let(:other_user) { create(:user, name: 'Carol', email: 'other_mail@mail.com') }
      let(:band3) { create(:band, name: 'The suits') }
      let(:band4) { create(:band, name: 'The shags') }

      before { other_user.bands << band3 }

      it 'returns only bands that belong to the user' do
        subject

        expect(response).to have_http_status(200)
        expect(json_response[:bands]).to be_an(Array)
        expect(json_response[:bands].size).to eq(2)
        expect(json_response[:bands].first['name']).to eq(band1.name)
        expect(json_response[:bands].second['name']).to eq(band2.name)
      end
    end
  end

  describe 'POST /users/:id/bands' do
    subject(:request) { post "/users/#{user.id}/bands", params: params, headers: headers }

    let(:user) { create(:user) }
    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
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

    context 'when authorized user tries to pass different user_id in url' do
      let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(some_user)}" } }
      let(:some_user) { create(:user, name: 'Adam', email: 'adam@mail.com', password: 'password') }

      it 'returns 403' do
        subject

        expect(response).to have_http_status(403)
      end
    end

    context 'with invalid authorization token' do
      let(:headers) { { HTTP_AUTHORIZATION: 'Token some_random_token' } }

      it 'returns 403' do
        subject

        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'PUT users/:id/bands/:id' do
    subject { put "/users/#{user.id}/bands/#{band.id}", params: params, headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:user) { create(:user) }
    let(:band) { create(:band, name: 'the stonks', phone_number: nil) }
    let(:params) { { band: { phone_number: '+1 0203 044 11' } } }

    before { user.bands << band }

    it 'updates attribute' do
      expect { subject }.to change { band.reload.phone_number }.from(nil).to(params[:band][:phone_number])
    end

    context 'when authorized user tries to pass different user_id in url' do
      let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(some_user)}" } }
      let(:some_user) { create(:user, name: 'Adam', email: 'adam@mail.com', password: 'password') }

      it 'returns 403' do
        subject

        expect(response).to have_http_status(403)
      end
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
