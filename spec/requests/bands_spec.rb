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
end
