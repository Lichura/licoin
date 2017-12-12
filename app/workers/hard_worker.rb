class HardWorker
  include Sidekiq::Worker

  def perform(*args)
    HardWorker.perform_async('bob', 5)
  end
end
