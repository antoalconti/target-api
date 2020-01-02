require 'rails_helper'

RSpec.describe 'PATCH /api/v1/users', type: :request do
  let!(:user) { create(:user) }
  let!(:header_param) { auth_headers.merge(accept: 'application/json') }

  context 'when the request is valid' do
    context 'when update personal info' do
      subject { patch user_registration_url, params: params, headers: header_param, as: :json }
      let(:params) do
        {
          user: {
            full_name: 'New Name'
          }
        }
      end

      it 'returns the success message' do
        subject
        expect(json).to include_json(
          user: {
            id: user.id,
            full_name: params[:user][:full_name],
            gender: user.gender,
            email: user.uid,
            avatar: polymorphic_url(user.avatar)
          }
        )
      end

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end

    context 'when update personal info and ulpload perfil picture' do
      subject { patch user_registration_url, params: params, headers: header_param }
      let(:params) do
        {
          user: {
            gender: 'female',
            avatar: Rack::Test::UploadedFile.new('spec/fixtures/other_image.jpeg', 'image/jpeg')
          }
        }
      end

      it 'returns the user info uploaded' do
        subject
        expect(json).to include_json(
          user: {
            id: user.id,
            full_name: user.full_name,
            gender: params[:user][:gender],
            email: user.uid,
            avatar: polymorphic_url(user.reload.avatar)
          }
        )
      end

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end

    context 'when update perfile picture info' do
      subject { patch user_registration_url, params: params, headers: header_param }
      let(:params) do
        {
          user: {
            avatar: Rack::Test::UploadedFile.new('spec/fixtures/other_image.jpeg', 'image/jpeg')
          }
        }
      end

      it 'returns the success message' do
        subject
        expect(json).to include_json(
          user: {
            id: user.id,
            gender: user.gender,
            email: user.uid,
            avatar: polymorphic_url(user.reload.avatar)
          }
        )
      end

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end
  end

  context 'when the request is not valid' do
    subject { patch user_registration_url, params: params, headers: headers, as: :json }

    context 'when the headers are empty' do
      let(:params) do
        {
          user: {
            full_name: 'New Name'
          }
        }
      end
      let(:headers) { nil }

      it 'returns the error messages as a json' do
        subject
        message = I18n.t('devise_token_auth.registrations.user_not_found')
        expect(json).to include_json(error: message)
      end

      it 'returns a unauthorized status' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when params is not permited' do
      let(:params) do
        {
          user: {
            unpermitted_param: 'value'
          }
        }
      end
      it 'returns the error messages as a json' do
        subject
        message = I18n.t('errors.messages.validate_account_update_params')
        expect(json).to include_json(error: message)
      end

      it 'returns a unprocessable entity status' do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
