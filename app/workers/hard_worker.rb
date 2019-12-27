class HardWorker
  include Sidekiq::Worker

  def perform
    # Target.where("created_at < ?", 7.days.ago)
    Topic.create(name: 'job')
  end
end
