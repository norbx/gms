# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'POST /create' do
    subject(:request) { post '/users', params: params }

    let(:params) do
      {
        user: {
          email: 'test@mail.com',
          username: 'test',
          password: 'hejhooo',
          first_name: 'test',
          last_name: 'test'
        }
      }
    end

    it 'creates a user' do
      expect{ request }.to change(User, :count).by(1)
    end

    it 'returns status created' do
      request

      expect(response).to have_http_status(201)
    end

    it 'returns a token' do
      request

      expect(json_response).to have_key(:token)
    end

    context 'with blank password' do
      before { params[:user][:password] = '' }

      it 'does not create a user' do
        expect{ request }.not_to change(User, :count)
      end

      it 'returns status unproccessable entity' do
        request

        expect(response).to have_http_status(422)
      end
    end

    context 'with missing password' do
      before { params[:user].delete(:password) }

      it 'does not create a user' do
        expect{ request }.not_to change(User, :count)
      end

      it 'returns status unproccessable entity' do
        request

        expect(response).to have_http_status(422)
      end
    end

  end
end
