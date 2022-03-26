# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BandsController, type: :request do
  describe 'GET /bands' do
    subject { get '/bands' }

    let(:band) { create(:band) }

    before do
      band.tags << create(:tag)
    end

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
      expect(json_response['bands'][0]['tags']).to be_an(Array)
      expect(json_response['bands'][0]['tags'][0]['id']).to be_present
      expect(json_response['bands'][0]['tags'][0]['name']).to be_present
    end

    it 'returns only active bands' do
      create(:band, active: false)
      create(:band)

      subject

      expect(json_response[:bands].count).to eq(2)
    end
  end

  describe 'GET /bands/:id' do
    subject { get "/bands/#{band.id}" }

    let(:band) { create(:band) }

    before do
      band.tags << create(:tag)
    end

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
      expect(json_response['band']['tags']).to be_an(Array)
      expect(json_response['band']['tags'][0]['id']).to be_present
      expect(json_response['band']['tags'][0]['name']).to be_present
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
      expect(json_response[:bands].map { _1[:name] }.sort).to match_array([band1.name, band2.name])
    end

    it 'returns only active bands' do
      user.bands << create(:band, active: false)
      user.bands << create(:band)

      subject

      expect(json_response[:bands].count).to eq(3)
    end

    context 'with bands belonging to different user' do
      let(:other_user) { create(:user) }
      let(:band3) { create(:band) }
      let(:band4) { create(:band) }

      before { other_user.bands << band3 }

      it 'returns only bands that belong to the user' do
        subject

        expect(response).to have_http_status(200)
        expect(json_response[:bands]).to be_an(Array)
        expect(json_response[:bands].size).to eq(2)
        expect(json_response[:bands].map { _1[:name] }.sort).to match_array([band1.name, band2.name])
      end
    end
  end

  describe 'POST /users/:id/bands' do
    subject(:subject) { post "/users/#{user.id}/bands", params: params, headers: headers }

    let(:user) { create(:user) }
    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:params) do
      {
        band: {
          name: 'test',
          description: 'test',
          contact_name: 'test',
          phone_number: 'number',
          social_links: 'sociallink.com',
          tags_attributes: [
            {
              name: 'Jazz'
            },
            {
              name: 'Rap'
            },
            {
              name: 'Disco'
            }
          ]
        }
      }
    end

    it 'creates a band with tags and returns successful response' do
      expect { subject }.to change(Band, :count).from(0).to(1)
      expect(Band.last.tags.count).to eq(3)
      expect(response).to have_http_status(201)
      expect(json_response).to be_a(Hash)
      expect(json_response[:band][:id]).to be_present
      expect(json_response[:band][:name]).to be_present
      expect(json_response[:band][:phone_number]).to be_present
      expect(json_response[:band][:contact_name]).to be_present
      expect(json_response[:band][:description]).to be_present
      expect(json_response[:band][:social_links]).to be_present
      expect(json_response[:band][:active]).to be_present
      expect(json_response[:band][:tags]).to be_an(Array)
      expect(json_response[:band][:tags][0]['id']).to be_present
      expect(json_response[:band][:tags][0]['name']).to be_present
    end

    context 'with one of the tags already existing' do
      before { create(:tag, name: 'Jazz') }

      it 'creates a band with 3 associated tags..' do
        expect { subject }.to change(Band, :count).by(1)
        expect(Band.last.tags.count).to eq(3)
      end

      it '..but does not create already exsisting tag' do
        expect { subject }.to change(Tag, :count).from(1).to(3)
      end
    end

    context 'when one of the tags is invalid' do
      let(:params) do
        {
          band: {
            name: 'test',
            description: 'test',
            contact_name: 'test',
            phone_number: 'number',
            social_links: 'sociallink.com',
            tags_attributes: [
              {
                name: 'Some--invalid  name'
              },
              {
                name: 'Rap'
              },
              {
                name: 'Disco'
              }
            ]
          }
        }
      end

      it 'returns 422, does not create a band and tags' do
        subject

        expect(response).to have_http_status(422)
        expect(Tag.count).to eq(0)
        expect(Band.count).to eq(0)
      end
    end

    context 'with blank band name' do
      before { params[:band][:name] = '' }

      it 'creates no band and returns error response' do
        expect { subject }.not_to change(Band, :count)
        expect(response).to have_http_status(422)
        expect(response.body).to include('Name can\'t be blank')
      end
    end

    include_examples 'User not signed in'
    include_examples 'User passess different user_id'
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

    include_examples 'User not signed in'
    include_examples 'User passess different user_id'
  end

  describe 'PUT users/:id/bands/:id/deactivation' do
    subject { put "/users/#{user.id}/bands/#{band.id}/deactivation", params: params, headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:params) { {} }
    let(:user) { create(:user) }
    let(:band) { create(:band) }

    before { user.bands << band }

    it 'returns status ok' do
      subject

      expect(response).to have_http_status(200)
    end

    it 'deactivates the band for a given user' do
      expect { subject }.to change { user.bands.active.count }.from(1).to(0)
                                                              .and change { band.reload.active }.from(true).to(false)
    end

    it 'does not delete the band' do
      expect { subject }.not_to(change { user.bands.count })
    end

    include_examples 'User not signed in'
    include_examples 'User passess different user_id'
  end

  describe 'PUT users/:id/bands/:id/activation' do
    subject { put "/users/#{user.id}/bands/#{band.id}/activation", params: params, headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:params) { {} }
    let(:user) { create(:user) }
    let(:band) { create(:band, active: false) }

    before { user.bands << band }

    it 'returns status ok' do
      subject

      expect(response).to have_http_status(200)
    end

    it 'activates the band for a given user' do
      expect { subject }.to change { user.bands.active.count }.from(0).to(1)
                                                              .and change { band.reload.active }.from(false).to(true)
    end

    include_examples 'User not signed in'
    include_examples 'User passess different user_id'
  end
end
