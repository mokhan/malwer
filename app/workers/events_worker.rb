require 'json'

class EventsWorker
  include Sneakers::Worker
  from_queue "worker.events",
    durable: true,
    ack: true,
    threads: 50,
    prefetch: 50,
    timeout_job_after: 1,
    exchange: "malwer.events"

  def work(event_json)
    logger.info event_json
    event = Event.create!(JSON.parse(event_json))
    logger.info("Create Event: #{event.id}")
    ack!
  end
end
