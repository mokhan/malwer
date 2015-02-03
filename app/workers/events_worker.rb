class EventsWorker
  include Sneakers::Worker
  from_queue "dashboard.events", env: nil

  def work(raw_post)
    Event.create!(raw_post)
    ack! # we need to let queue know that message was received
  end
end
