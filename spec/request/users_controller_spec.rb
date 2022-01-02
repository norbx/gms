# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'POST /create' do
    subject(:request) { post '/users', params: params }

    let(:params) do
      {
        user: {
          username: 'test',
          password: 'hejho',
          first_name: 'test',
          last_name: 'test'
        }
      }
    end

    it 'creates a user' do
      expect(request).to change(User, :count).by(1)
    end

    context 'with blank password' do
      before { params[:passowrd] = '' }

      it 'does not create a user' do
        expect(request).not_to change(User, :count)
      end
    end

    context 'with missing password' do
      before { params.delete(:password) }

      it 'does not create a user' do
        expect(request).not_to change(User, :count)
      end
    end

  end
end
