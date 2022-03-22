# frozen_string_literal: true

RSpec.shared_examples 'User not signed in' do
  context 'when user is not signed in' do
    let(:headers) { {} }

    it 'returns status unauthorized' do
      subject

      expect(response).to have_http_status(401)
    end
  end
end
