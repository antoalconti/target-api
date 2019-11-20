RSpec.describe 'GET /api/v1/Targets/:id', type: :request do
  subject { get api_v1_target_url(target_id), as: :json }

  context 'when the request is valid' do
    let(:topic) { create(:topic) }
    let(:target) { create(:target, topic: topic) }
    let(:target_id) { target.id }

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
    let(:target_id) { 'Invalid topic_id' }

    it 'returns the error messages as a json' do
      subject
      expect(response.body).to include_json(error: 'Record not found')
    end

    it 'returns a not found status' do
      subject
      expect(response).to have_http_status(:not_found)
    end
  end
end
