require 'rails_helper'

RSpec.describe Chat, type: :model do
  subject { create(:chat) }

  describe 'associations' do
    it { should have_many(:messages) }
    it { should belong_to(:user_a) }
    it { should belong_to(:user_b) }
  end
end
