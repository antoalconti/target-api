require 'rails_helper'

RSpec.describe Topic, type: :model do
  subject { create(:topic) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:targets) }
  end

  describe '.create' do
    it 'creates the topic' do
      expect { subject }.to change { Topic.count }.by(1)
    end

    it 'has the given name' do
      create(:topic, name: 'Sports')
      expect(Topic.last.name).to eq('Sports')
    end
  end
end
