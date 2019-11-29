RSpec.describe 'POST /api/v1/users/sign_in', type: :request do
  subject { post user_session_url, params: user_params, as: :json }

  context 'when the request is valid' do
    let(:user) { create(:user) }
    let(:user_params) do
      {
        user:
          {
            email: user.email,
            password: user.password
          }
      }
    end

    it 'returns the user' do
      subject
      expect(json).to include_json(
        user: {
          id: user.id,
          email: user.email,
          provider: user.provider,
          full_name: user.full_name,
          gender: user.gender,
          uid: user.uid
        }
      )
    end

    it 'returns a success status' do
      subject
      expect(response).to be_successful
    end

    it 'returns the user with token in the header' do
      subject
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end
  end

  context 'when the user not exist' do
    let(:user_params) do
      {
        user:
          {
            email: 'no_user@mail',
            password: 'no_user'
          }
      }
    end

    it 'returns the error message' do
      subject
      error_msg = I18n.t('api.errors.invalid_credentials')
      expect(json).to include_json(errors: [error_msg])
    end

    it 'returns a unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'when the user did not confirm the account' do
    let(:user_not_confirmed) { create(:user, :not_confirmed) }
    let(:user_params) do
      {
        user:
          {
            email: user_not_confirmed.email,
            password: user_not_confirmed.password
          }
      }
    end

    it 'returns the error message' do
      subject
      error_msg = I18n.t('api.errors.email_not_confirmed', email: user_not_confirmed.email)
      expect(json).to include_json(errors: [error_msg])
    end

    it 'returns a unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
