require 'rails_helper'

RSpec.describe 'PATCH /api/v1/users/password', type: :request do
  let(:user) { create(:user) }
  let(:password_token) { user.send(:set_reset_password_token) }
  let(:get_params) do
    {
      reset_password_token: password_token,
      redirect_url: ENV['PASSWORD_RESET_URL']
    }
  end

  before do
    get edit_user_password_path, params: get_params, headers: auth_headers
    edit_response_params = Addressable::URI.parse(response.header['Location']).query_values
    @headers = {
      'access-token' => edit_response_params['token'],
      'uid' => edit_response_params['uid'],
      'client' => edit_response_params['client_id']
    }
  end

  subject { patch user_password_url, params: params, headers: @headers, as: :json }

  context 'when the request is valid' do
    let(:params) do
      {
        password: 'Newpass123',
        password_confirmation: 'Newpass123'
      }
    end

    it 'returns the success message' do
      subject
      message = I18n.t('devise_token_auth.passwords.successfully_updated')
      expect(json).to include_json(message: message)
    end

    it 'returns a success status' do
      subject
      expect(response).to be_successful
    end

    it 'updates the user reset password token' do
      expect(user.reload.reset_password_token).to be_present
      subject
      expect(user.reload.reset_password_token).to be_nil
    end
  end

  context 'when the request is not valid' do
    context 'when the user does not request reset password' do
      let(:params) { nil }

      before { @headers = nil }

      it 'returns the error messages as a json' do
        subject
        expect(json).to include_json(errors: ['Unauthorized'])
      end

      it 'returns a unauthorized status' do
        subject
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when params is missing' do
      let(:params) do
        {
          password_confirmation: 'Newpass123'
        }
      end

      it 'returns the error messages as a json' do
        subject
        message = I18n.t('devise_token_auth.passwords.missing_passwords')
        expect(json).to include_json(errors: [message])
      end

      it 'returns a unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the password_confirmation does not match password' do
      let(:params) do
        {
          password: 'Newpass1',
          password_confirmation: 'Newpass123'
        }
      end

      it 'returns the error messages as a json' do
        subject
        message = I18n.t('api.errors.doesnt_match_with_password')
        expect(json).to include_json(errors: { full_messages: [message] })
      end

      it 'returns a unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when the password length is too short' do
      let(:params) do
        {
          password: 'Newp',
          password_confirmation: 'Newp'
        }
      end

      it 'returns the error messages as a json' do
        subject
        message = I18n.t('api.errors.password_length')
        expect(json).to include_json(errors: { full_messages: [message] })
      end

      it 'returns an unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
