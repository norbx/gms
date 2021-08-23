require 'rails_helper'

RSpec.describe "Users", type: :controller do
  describe "GET /index" do
    subject { get "/users/index" }

    let(:user) { create(:user) }

    it "returns http success" do
      sign_in user
      subject
      expect(response).to have_http_status(:success)
    end

    include_examples 'User not signed in'
  end

end
