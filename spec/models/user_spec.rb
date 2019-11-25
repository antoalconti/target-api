require 'rails_helper'

RSpec.describe User, type: :model do
  subject { create(:user) }

  describe 'validations' do
    it { should validate_presence_of(:full_name) }
  end

  describe 'associations' do
    it { should have_many(:targets) }
  end
end
