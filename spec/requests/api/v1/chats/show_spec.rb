require 'rails_helper'

RSpec.describe 'GET /api/v1/chats/:id', type: :request do
  subject { get api_v1_chat_url(param), headers: headers, as: :json }

  let!(:user) { create(:user) }
  let!(:chat) { create(:chat, user_a: user) }

  context 'with logged-in user' do
    let(:headers) { auth_headers }

    context 'when the request is valid and the chat has messages' do
      let(:param) { chat.id }

      context 'when the chat has messages' do
        let!(:messages) { create_list(:message, 3, chat: chat) }

        it 'returns the chat and the messages as a json' do
          subject
          chat_messages = messages.map do |message|
            {
              user_id: message.user.id,
              text: message.text,
              created_at: message.created_at.as_json
            }
          end
          expect(json).to include_json(
            chat: {
              id: chat.id,
              unread_messages: chat.unread_messages_count(user),
              user: {
                id: chat.other_user(user).id,
                full_name: chat.other_user(user).full_name
              }
            },
            chat_messages: chat_messages
          )
        end

        it 'returns a success status' do
          subject
          expect(response).to be_successful
        end
      end

      context 'when the chat has not messages' do
        it 'returns the chat and the messages as a json' do
          subject
          expect(json).to include_json(
            chat: {
              id: chat.id,
              unread_messages: 0,
              user: {
                id: chat.other_user(user).id,
                full_name: chat.other_user(user).full_name
              }
            },
            chat_messages: []
          )
        end

        it 'returns a success status' do
          subject
          expect(response).to be_successful
        end
      end
    end

    context 'when the request is not valid' do
      let(:param) { 'Invalid chat_id' }

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
