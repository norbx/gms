# frozen_string_literal: true

RSpec.describe TagsController do
  describe 'GET /tags' do
    subject { get '/tags', headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:user) { create(:user) }

    before { create(:tag) }

    it 'returns a list of all tags' do
      subject

      expect(response).to have_http_status(200)
      expect(json_response[:tags]).to be_an(Array)
      expect(json_response[:tags][0]).to be_a(Hash)
      expect(json_response[:tags][0][:id]).to be_present
      expect(json_response[:tags][0][:name]).to be_present
    end

    include_examples 'User not signed in'
  end

  describe 'GET /tags/:id' do
    subject { get "/tags/#{tag.id}", headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:user) { create(:user) }
    let(:tag) { create(:tag) }

    it 'returns a list of all tags' do
      subject

      expect(response).to have_http_status(200)
      expect(json_response[:tag]).to be_a(Hash)
      expect(json_response[:tag][:id]).to be_present
      expect(json_response[:tag][:name]).to be_present
    end

    include_examples 'User not signed in'
  end
end
