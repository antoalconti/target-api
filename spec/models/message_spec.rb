require 'rails_helper'

RSpec.describe Message, type: :model do
  subject { create(:message) }

  describe 'validations' do
    it { should validate_presence_of(:text) }

    describe '#user_belongs_to_chat' do
      let!(:user_a) { create(:user) }
      let!(:user_b) { create(:user) }
      let!(:chat_a) { create(:chat, user_a: user_a, user_b: user_b) }

      context 'when user is no one of chat users' do
        let(:user) { create(:user) }
        subject { build(:message, chat: chat_a, user: user) }

        it 'does not create message with user_b' do
          error_message = I18n.t('api.models.message.errors.chat_different_users')
          subject.valid?
          expect(subject.errors.messages).to include(message: [error_message])
        end
      end

      context 'when user is user_a of chat users' do
        subject { create(:message, chat: chat_a, user: user_a) }

        it 'creates a message' do
          expect { subject }.to change { Message.count }.by(1)
        end
      end

      context 'when user is user_b of chat users' do
        subject { create(:message, chat: chat_a, user: user_b) }

        it 'creates a message' do
          expect { subject }.to change { Message.count }.by(1)
        end
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:chat) }
    it { should belong_to(:user) }
  end
end
