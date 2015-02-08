require 'json'

class EventIntake
  include Sneakers::Worker
  from_queue "worker.events"

  def work(event_json)
    logger.info event_json
    json = JSON.parse(event_json)
    json['type'] = json['type'].capitalize
    event = Event.create!(json)
    logger.info("Create Event: #{event.id}")
    ack!
  end
end
