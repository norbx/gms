# frozen_string_literal: true

RSpec.shared_examples 'User not signed in' do
  context 'when the user is not signed in' do
    before do
      @current_user = nil
      @current_user_id = nil
    end

    it 'returns status 401' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
