require 'json'

class EventIntake
  include Sneakers::Worker
  from_queue "worker.events"

  def work(event_json)
    logger.info event_json
    event = Event.create!(JSON.parse(event_json))
    logger.info("Create Event: #{event.id}")
    ack!
  end
end