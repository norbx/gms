# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BandsController, type: :request do
  describe 'GET /bands' do
    subject { get '/bands', params: params }

    let(:band) { create(:band) }
    let(:params) { { search: band.name.to_s } }

    before do
      band.tags << create(:tag)
      BandsIndex.import
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
      subject
      expect(json_response[:bands].count).to eq(1)
    end
  end

  describe 'GET /bands/:id' do
    subject { get "/bands/#{band.id}" }

    let(:band) { create(:band) }

    before do
      band.tags << create(:tag)
    end

    it 'returns status 200' do
      subject

      expect(response).to have_http_status(200)
    end

    include_examples 'Band response'
  end
end
