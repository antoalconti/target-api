require 'rails_helper'

RSpec.describe 'DELETE /api/v1/targets/:id', type: :request do
  subject { delete api_v1_target_url(param), headers: headers, as: :json }

  let!(:user) { create(:user) }
  let(:target) { create(:target) }

  context 'with logged-in user' do
    let(:headers) { auth_headers }

    context 'when the request is valid' do
      let(:param) { target.id }

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end

    context 'when the request is not valid' do
      let(:param) { 'Invalid target_id' }

      it 'returns the error messages as a json' do
        subject
        expect(json).to include_json(error: 'Record not found')
      end

      it 'returns a not found status' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  context 'when the user is not authenticated' do
    let(:headers) { nil }
    let(:param) { 0 }

    it 'returns the error messages as a json' do
      subject
      expect(json).to include_json(errors: [I18n.t('devise.failure.unauthenticated')])
    end

    it 'returns an unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
