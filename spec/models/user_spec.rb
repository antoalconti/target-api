require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:full_name) }
    it { should validate_presence_of(:gender) }
    it { should define_enum_for(:gender).with_values(User.genders) }
  end

  describe 'associations' do
    it { should have_many(:targets) }
  end

  describe '#chats' do
    let(:user) { create(:user) }
    let(:chat_a) { create(:chat, user_a: user) }
    let(:chat_b) { create(:chat, user_b: user) }
    it 'should return chats collections' do
      expect(user.reload.chats).to match_array([chat_a, chat_b])
    end
  end
end
