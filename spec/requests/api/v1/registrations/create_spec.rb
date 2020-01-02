require 'rails_helper'

RSpec.describe 'POST /api/v1/users', type: :request do
  subject { post user_registration_url, params: user_params, as: :json }

  context 'when the request is valid' do
    let(:user_params) do
      {
        user: attributes_for(:user)
      }
    end

    it 'returns the user' do
      subject
      expect(json).to include_json(
        user: {
          email: user_params[:user][:email],
          full_name: user_params[:user][:full_name],
          gender: user_params[:user][:gender]
        }
      )
    end

    it 'returns a success status' do
      subject
      expect(response).to be_successful
    end

    it 'creates a user' do
      expect { subject }.to change { User.count }.from(0).to(1)
    end
  end

  context 'when user email is already registred' do
    let!(:user) { create(:user) }
    let(:user_params) do
      {
        user: attributes_for(:user, email: user.email)
      }
    end

    it 'returns the error messages' do
      subject
      expect(json).to include_json(errors: { email: ['has already been taken'] })
    end

    it 'returns a unprocessable entity status' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not create a user' do
      expect { subject }.not_to change { User.count }
    end
  end

  context 'when user params is missing' do
    let(:user_params) do
      {
        user: attributes_for(:user).except(:email)
      }
    end

    it 'returns the error messages' do
      subject
      expect(json).to include_json(errors: { email: ['can\'t be blank'] })
    end

    it 'returns a unprocessable entity status' do
      subject
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'does not create a user' do
      expect { subject }.not_to change { User.count }
    end
  end
end
