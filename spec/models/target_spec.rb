require 'rails_helper'

RSpec.describe Target, type: :model do
  subject { create(:target) }

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:radius) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it {
      should validate_numericality_of(:radius)
        .is_greater_than(0).is_less_than_or_equal_to(1000)
    }
  end

  describe 'associations' do
    it { should belong_to(:topic) }
  end

  describe '.create' do
    it 'creates the target' do
      expect { subject }.to change { Target.count }.from(0).to(1)
    end

    it 'has the given topic' do
      topic = create(:topic)
      create(:target, topic: topic)
      expect(Target.last.topic).to eq(topic)
    end
  end
end
