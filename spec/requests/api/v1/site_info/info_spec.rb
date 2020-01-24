require 'rails_helper'

RSpec.describe 'GET /api/v1/site_infos/info', type: :request do
  subject { get info_api_v1_site_infos_url, headers: headers, as: :json }

  let!(:user) { create(:user) }

  context 'with logged-in user' do
    let(:headers) { auth_headers }

    context 'when the request is valid' do
      let!(:site_info) { create(:site_info) }

      it 'returns the info about the site' do
        subject
        expect(json).to include_json(site_info: { info: site_info.info })
      end

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end

    context 'when there is not site info' do
      it 'returns an error as json' do
        subject
        expect(json).to include_json(error: I18n.t('api.models.site_info.no_info'))
      end

      it 'returns a success status' do
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
