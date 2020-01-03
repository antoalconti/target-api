require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!
RSpec.describe HardWorker, type: :worker do
  let!(:targets_to_delete) { create_list(:target, 3, created_at: Time.zone.today - 10.days) }
  let!(:targets_to_keep) { create_list(:target, 2) }

  let(:time) { (Time.zone.today + 7.hours).to_datetime }
  let(:scheduled_job) { described_class.perform_in(time, 'Awesome', true) }

  it 'occurs at expected time' do
    scheduled_job
    assert_equal true, described_class.jobs.last['jid'].include?(scheduled_job)
    expect(described_class).to have_enqueued_sidekiq_job('Awesome', true)
  end

  it 'goes into the jobs array for testing environment' do
    expect do
      described_class.perform_async
    end.to change(described_class.jobs, :size).by(1)
  end

  it 'does execute job and destroy targets a week older' do
    expect do
      HardWorker.new.perform
    end.to change { Target.count }.from(5).to(2)
  end
end
