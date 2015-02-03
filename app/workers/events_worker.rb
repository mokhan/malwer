class EventsWorker
  include Sneakers::Worker
  from_queue "dashboard.events", env: nil

  def work(raw_post)
    Event.create!(raw_post)
    ack!
  end
end
