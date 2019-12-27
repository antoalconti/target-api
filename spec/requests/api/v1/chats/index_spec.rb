require 'rails_helper'

RSpec.describe 'GET /api/v1/chats', type: :request do
  subject { get api_v1_chats_url, headers: headers, as: :json }

  let(:user) { create(:user) }

  context 'with logged-in user' do
    let(:headers) { auth_headers }

    context 'when the request is valid and the user has chats' do
      let!(:chats) { create_list(:chat, 5, user_a: user) }
      let!(:other_chats) { create_list(:chat, 4) }

      it 'returns the collection of chats as a json' do
        subject
        chats_collection = chats.map do |chat|
          {
            id: chat.id,
            unread_messages: chat.unread_messages_count(user),
            user: {
              id: chat.other_user(user).id,
              full_name: chat.other_user(user).full_name
            }
          }
        end

        expect(json[:chats]).to match_unordered_json(
          chats_collection
        )
      end

      it 'returns a success status' do
        subject
        expect(response).to be_successful
      end
    end

    context 'when the request is valid and the user has not chats' do
      it 'returns empty chats collection' do
        subject
        expect(json).to include_json(chats: [])
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
