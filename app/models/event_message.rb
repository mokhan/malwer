class EventMessage
  attr_reader :agent_id, :event_type, :data

  def initialize(agent_id:, event_type:, data: {})
    @agent_id = agent_id
    @event_type = event_type
    @data = data
  end

  def routing_key
    "events.#{event_type}.#{agent_id}"
  end

  def to_hash
    {
      agent_id: agent_id,
      type: event_type,
      data: data
    }
  end

  def to_json
    to_hash.to_json
  end
end
