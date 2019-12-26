require 'rails_helper'

RSpec.describe 'GET /api/v1/targets/:id', type: :request do
  subject { get api_v1_target_url(param), headers: headers, as: :json }

  let!(:user) { create(:user) }
  let(:topic) { create(:topic) }
  let(:target) do
    create(:target, topic: topic,
                    latitude: 34.905311, longitude: 56.185386, radius: 950)
  end
  let!(:matches_of_my_target) do
    create_list(:target, 2, topic_id: topic.id,
                            latitude: 34.905311, longitude: 56.185386, radius: 950)
  end

  context 'with logged-in user' do
    let(:headers) { auth_headers }

    context 'when the request is valid' do
      let(:param) { target.id }

      it 'returns the target and the target matches as a json' do
        subject
        target_matches = TargetMatchingService.new(Target.last).matches
        target_matches = target_matches.map do |target|
          {
            topic_id: target.topic.id,
            user_id: target.user.id,
            title: target.title,
            radius: target.radius,
            longitude: target.longitude.to_s,
            latitude: target.latitude.to_s
          }
        end
        expect(json).to include_json(
          target: {
            topic_id: topic.id,
            title: target.title,
            radius: target.radius,
            longitude: target.longitude.to_s,
            latitude: target.latitude.to_s
          },
          target_matches: target_matches
        )
      end

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
