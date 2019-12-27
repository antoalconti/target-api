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
    subject { create(:chat, user_a: user_a, user_b: user_b) }

    it 'should return chat users' do
      subject.valid?
      expect(subject.users).to match_array([user_a, user_b])
    end
  end

  describe '#other_user' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    subject { create(:chat, user_a: user_a, user_b: user_b) }

    it 'should return the other user' do
      expect(subject.other_user(user_b)).to eq(user_a)
    end
  end

  describe '#unread_messages_count' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let!(:messages) { create_list(:message, 4, user: user_b, seen: false, chat: subject) }
    subject { create(:chat, user_a: user_a, user_b: user_b) }

    it 'should return unread messages count' do
      expect(subject.unread_messages_count(user_a)).to eq(4)
    end
  end

  describe '#clean_unread_messages' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let!(:messages) { create_list(:message, 4, user: user_b, seen: false, chat: subject) }
    subject { create(:chat, user_a: user_a, user_b: user_b) }

    it 'should mark as read all unread messages' do
      subject.clean_unread_messages(user_a)
      expect(subject.unread_messages_count(user_a)).to eq(0)
    end
  end
end
