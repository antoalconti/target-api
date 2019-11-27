RSpec.describe 'GET /api/v1/Targets/:id', type: :request do
  subject { get api_v1_target_url(param), headers: auth_headers, as: :json }

  let!(:user) { create(:user) }
  let(:topic) { create(:topic) }

  context 'when the request is valid' do
    let(:target) { create(:target, topic: topic) }
    let(:param) { target.id }

    it 'returns the target as a json' do
      subject
      expect(response.body).to include_json(
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
      expect(response.body).to include_json(error: 'Record not found')
    end

    it 'returns a not found status' do
      subject
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when the user is not authenticated' do
    subject { post api_v1_targets_url, params: target_params, as: :json }

    let(:target_params) do
      {
        target: attributes_for(:target).merge(topic_id: topic.id)
      }
    end

    it 'returns the error messages as a json' do
      subject
      expect(response.body).to include_json(errors: [I18n.t('devise.failure.unauthenticated')])
    end

    it 'returns a unauthorized status' do
      subject
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
