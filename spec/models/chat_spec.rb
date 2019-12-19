require 'rails_helper'

RSpec.describe Chat, type: :model do
  subject { create(:chat) }

  describe 'associations' do
    it { should have_many(:messages) }
    it { should belong_to(:user_a) }
    it { should belong_to(:user_b) }
  end

  describe '#users' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:chat) { create(:chat, user_a: user_a, user_b: user_b) }

    it 'should return chats collections' do
      expect(chat.reload.users).to match_array([user_a, user_b])
    end
  end
end
