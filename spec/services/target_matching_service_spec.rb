require 'rails_helper'

RSpec.describe TargetMatchingService do
  let!(:user) { create(:user) }
  let(:topic_a) { create(:topic) }
  let(:topic_b) { create(:topic) }
  let(:target) do
    create(:target, user_id: user.id, topic_id: topic_a.id,
                    latitude: 34.902425, longitude: 56.177360, radius: 500)
  end
  subject { TargetMatchingService.new(target).matches }

  context 'when the radius of each target touches at some point' do
    context 'when is the same topic and belongs to diferent users' do
      let!(:target_not_in_radius) do
        create(:target, topic: topic_a, latitude: 34.905311, longitude: 56.185386, radius: 150)
      end
      let!(:target_in_radius) do
        create(:target, topic: topic_a, latitude: 34.905311, longitude: 56.185386, radius: 900)
      end
      let!(:other_target_in_radius) do
        create(:target, topic: topic_a, latitude: 34.902742, longitude: 56.183395, radius: 100)
      end

      it 'returns a list of matches' do
        expect(subject).to contain_exactly(target_in_radius, other_target_in_radius)
      end
    end

    context 'when is not the same topic and belongs to different users' do
      let!(:target_in_radius) do
        create(:target, topic: topic_b, latitude: 34.905311, longitude: 56.185386, radius: 900)
      end

      it 'returns an empty list of matches' do
        expect(subject).to be_empty
      end
    end

    context 'when the target is the same topic, in radius and same user' do
      let!(:target_in_radius) do
        create(:target, topic: topic_a, user_id: user.id,
                        latitude: 34.905311, longitude: 56.185386, radius: 900)
      end

      it 'returns an empty list of matches' do
        expect(subject).to be_empty
      end
    end
  end

  context 'when the radius of each target does not touch' do
    let!(:target_usa) do
      create(:target, topic: topic_a, latitude: 35.998352, longitude: -118.713486, radius: 150)
    end

    it 'returns an empty list of matches' do
      expect(subject).to be_empty
    end
  end
end
