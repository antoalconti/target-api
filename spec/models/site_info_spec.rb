require 'rails_helper'

RSpec.describe SiteInfo, type: :model do
  subject { create(:site_info) }

  describe '.create' do
    it 'creates the About section' do
      expect { subject }.to change { SiteInfo.count }.by(1)
    end

    it 'has the given info' do
      create(:site_info, info: 'Is located in mvd.')
      expect(SiteInfo.last.info).to eq('Is located in mvd.')
    end
  end
end
