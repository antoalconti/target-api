require 'rails_helper'

RSpec.describe 'POST /api/v1/users/password', type: :request do
  subject { post user_password_url, params: params, as: :json }

  context 'when the request is valid' do
    let!(:user) { create(:user) }
    let(:params) do
      {
        'email': user.email,
        'redirect_url': ENV['SERVER_URL']
      }
    end

    it 'returns the success message' do
      subject
      message = I18n.t('devise_token_auth.passwords.sended', email: user.email)
      expect(json).to include_json(message: message)
    end

    it 'returns a success status' do
      subject
      expect(response).to be_successful
    end

    it 'updates the user reset password token' do
      expect(user.reload.reset_password_token).to be_nil
      subject
      expect(user.reload.reset_password_token).to be_present
    end
  end

  context 'when the request is not valid' do
    let(:params) do
      {
        'email': 'inavlid_email',
        'redirect_url': ENV['SERVER_URL']
      }
    end

    it 'returns the error message' do
      subject
      message = I18n.t('devise_token_auth.passwords.user_not_found', params { :email })
      expect(json).to include_json(errors: [message])
    end

    it 'returns a not found status' do
      subject
      expect(response).to have_http_status(:not_found)
    end
  end
end
