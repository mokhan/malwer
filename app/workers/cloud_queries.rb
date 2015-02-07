require 'json'

class CloudQueries
  include Sneakers::Worker
  from_queue "worker.queries"

  def work(json)
    logger.info "Query for: #{json.inspect}"
    attributes = JSON.parse(json)

    fingerprint = attributes["fingerprint"]
    disposition = Disposition.find_by(fingerprint: fingerprint)

    publish(JSON.generate({
      name: :scanned,
      agent_id: attributes["agent_id"],
      data: attributes["data"]
    }), to_queue: "worker.events")

    if disposition.nil?
      publish(JSON.generate({
        command: :request_analysis,
        agent_id: attributes["agent_id"],
        fingerprint: fingerprint,
      }), routing_key: "malwer.agents.#{attributes["agent_id"]}")
    end

    ack!
  end
end
