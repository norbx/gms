# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'POST /users' do
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

    it 'creates a user and returns successful response' do
      expect { request }.to change(User, :count).by(1)
      expect(response).to have_http_status(201)
      expect(json_response).to have_key(:token)
    end

    context 'with blank password' do
      before { params[:user][:password] = '' }

      it 'creates no user and returns error response' do
        expect { request }.not_to change(User, :count)
        expect(response).to have_http_status(422)
        expect(response.body).to include('Password can\'t be blank', 'Password is too short (minimum is 6 characters)')
      end
    end

    context 'with blank username' do
      before { params[:user][:username] = '' }

      it 'creates no user and returns error response' do
        expect { request }.not_to change(User, :count)
        expect(response).to have_http_status(422)
        expect(response.body).to include('Username can\'t be blank')
      end
    end

    context 'with blank email' do
      before { params[:user][:email] = '' }

      it 'creates no user and returns error response' do
        expect { request }.not_to change(User, :count)
        expect(response).to have_http_status(422)
        expect(response.body).to include('Email can\'t be blank')
      end
    end
  end
end
