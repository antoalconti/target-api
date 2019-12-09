require 'rails_helper'

RSpec.describe 'GET /api/v1/Targets', type: :request do
  subject { get api_v1_targets_url, headers: headers, as: :json }

  let(:user) { create(:user) }
  let(:topic) { create(:topic) }

  context 'with logged-in user' do
    let(:headers) { auth_headers }

    context 'when the request is valid and the user has targets' do
      let!(:targets) { create_list(:target, 5, user: user, topic: topic) }
      let!(:other_targets) { create_list(:target, 4) }

      it 'returns the collection of targets as a json' do
        subject
        targets_collection = targets.map do |target|
          {
            topic_id: topic.id,
            user_id: user.id,
            title: target.title,
            radius: target.radius,
            longitude: target.longitude.to_s,
            latitude: target.latitude.to_s
          }
        end

        expect(json).to include_json(
          targets: targets_collection
        )
      end

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end

    context 'when the request is valid and the user has not targets' do
      it 'returns empty targets collection' do
        subject
        expect(json).to include_json(targets: [])
      end

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end
  end

  context 'when the user is not authenticated' do
    let(:headers) { nil }

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
