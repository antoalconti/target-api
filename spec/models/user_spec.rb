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
end
