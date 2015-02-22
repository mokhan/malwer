require 'json'

class EventIntake
  include Sneakers::Worker
  from_queue "worker.events"

  def work(event_json)
    logger.info(event_json)
    Event.create!(to_hash(event_json))
    ack!
  end

  private

  def to_hash(json)
    JSON.parse(json).tap do |event|
      event['type'].capitalize!
    end
  end
end
