# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profile actions' do
  describe 'GET /profile/bands' do
    subject { get '/profile/bands', headers: headers }

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

  describe 'POST /profile/bands' do
    subject(:subject) { post '/profile/bands', params: params, headers: headers }

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
      expect(json_response[:band][:image_urls]).to be_an(Array)
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
  end

  describe 'PUT profile/bands/:id' do
    subject { put "/profile/bands/#{band.id}", params: params, headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:user) { create(:user) }
    let(:band) { create(:band, name: 'the stonks', phone_number: nil) }
    let(:params) { { band: { phone_number: '+1 0203 044 11' } } }

    before { user.bands << band }

    it 'updates attribute and returns status 200' do
      expect { subject }.to change { band.reload.phone_number }.from(nil).to(params[:band][:phone_number])
      expect(response).to have_http_status(200)
    end

    include_examples 'Band response'
    include_examples 'User not signed in'
  end

  describe 'PUT profile/bands/:id/deactivation' do
    subject { put "/profile/bands/#{band.id}/deactivation", params: params, headers: headers }

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

    include_examples 'Band response'
    include_examples 'User not signed in'
  end

  describe 'PUT /profile/bands/:id/activation' do
    subject { put "/profile/bands/#{band.id}/activation", params: params, headers: headers }

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

    include_examples 'Band response'
    include_examples 'User not signed in'
  end

  describe 'PUT /profile/bands/:id/images' do
    subject { put "/profile/bands/#{band.id}/images", params: params, headers: headers }

    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(user)}" } }
    let(:images) do
      [
        Rack::Test::UploadedFile.new(Rails.root.join('spec/', 'fixtures/', 'images/', 'avatar.jpg'), 'image/jpeg',
                                     true),
        Rack::Test::UploadedFile.new(Rails.root.join('spec/', 'fixtures/', 'images/', 'band.jpg'), 'image/jpeg', true)
      ]
    end
    let(:params) { { band: { images: images } } }
    let(:user) { create(:user) }
    let(:band) { create(:band, active: false, images: []) }

    before { user.bands << band }

    it 'creates and attaches images, returns succesful response' do
      expect { subject }.to change { band.images.count }.from(0).to(2)
      expect(response).to have_http_status(201)
    end

    include_examples 'Band response'
    include_examples 'User not signed in'
  end
end
