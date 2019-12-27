class HardWorker
  include Sidekiq::Worker

  def perform
    Target.where('created_at < ?', 7.days.ago).destroy_all
  end
end
