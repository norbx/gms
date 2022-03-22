# frozen_string_literal: true

RSpec.shared_examples 'User passess different user_id' do
  context 'with different id given' do
    let(:headers) { { HTTP_AUTHORIZATION: "Token #{JwtToken.generate_token(create(:user))}" } }

    it 'returns status forbidden' do
      subject

      expect(response).to have_http_status(403)
    end
  end
end
