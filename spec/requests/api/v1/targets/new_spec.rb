require 'rails_helper'

RSpec.describe 'GET /api/v1/targets/new', type: :request do
  subject { get new_api_v1_target_url, headers: headers, as: :json }

  context 'with logged-in user' do
    let!(:topics) { create_list(:topic, 7) }
    let(:user) { create(:user) }
    let(:headers) { auth_headers }

    context 'when the request is valid' do
      it 'returns the collection of topics as a json' do
        subject
        topics_collection = topics.map do |topic|
          {
            id: topic.id,
            name: topic.name
          }
        end

        expect(json).to include_json(
          topics: topics_collection
        )
      end

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end

    context 'when the request is valid and there are no topics' do
      it 'returns empty topics collection' do
        subject
        expect(json).to include_json(topics: [])
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
