require 'rails_helper'

RSpec.describe 'GET /api/v1/Targets/:id', type: :request do
  subject { get api_v1_target_url(param), headers: headers, as: :json }

  let!(:user) { create(:user) }
  let(:topic) { create(:topic) }
  let(:target) { create(:target, topic: topic) }

  context 'with logged-in user' do
    let(:headers) { auth_headers }

    context 'when the request is valid' do
      let(:param) { target.id }

      it 'returns the target as a json' do
        subject
        expect(json).to include_json(
          target: {
            topic_id: topic.id,
            title: target.title,
            radius: target.radius,
            longitude: target.longitude.to_s,
            latitude: target.latitude.to_s
          }
        )
      end

      it 'returns a created status' do
        subject
        expect(response).to be_successful
      end
    end

    context 'when the request is not valid' do
      let(:param) { 'Invalid topic_id' }

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

    it 'returns a unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
