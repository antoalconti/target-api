require 'rails_helper'

RSpec.describe ChatGeneratorService do
  let!(:user) { create(:user) }
  let(:topic) { create(:topic) }
  let!(:target) do
    create(:target, user_id: user.id, topic: topic,
                    latitude: 34.902425, longitude: 56.177360, radius: 500)
  end
  let(:matches) { TargetMatchingService.new(target).matches }

  subject { ChatGeneratorService.new(user, matches).create }

  context 'when chats do not exist yet between the matching users' do
    let!(:three_matching_targets) do
      create_list(:target, 3, topic: topic, latitude: 34.905311, longitude: 56.185386, radius: 900)
    end

    it 'creates a chat per target match' do
      expect { subject }.to change { Chat.count }.from(0).to(3)
    end
  end

  context 'when more than one target matches belong to the same user' do
    let(:other_user) { create(:user) }
    let!(:three_matching_targets) do
      create_list(:target, 3, topic: topic, latitude: 34.905311,
                              longitude: 56.185386, radius: 900, user: other_user)
    end

    it 'creates a chat' do
      expect { subject }.to change { Chat.count }.from(0).to(1)
    end
  end

  context 'when already exists a chat between the users' do
    let(:other_user) { create(:user) }
    let!(:matching_target) do
      create(:target, topic: topic, latitude: 34.905311,
                      longitude: 56.185386, radius: 900, user: other_user)
    end
    before { Chat.create(user_a: user, user_b: other_user) }

    it 'does not create a chat' do
      expect { subject }.not_to change { Chat.count }
    end
  end
end
