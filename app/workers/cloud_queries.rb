require 'json'

class CloudQueries
  include Sneakers::Worker
  from_queue "worker.queries"

  def work(json)
    logger.info "Query for: #{json.inspect}"
    attributes = JSON.parse(json)

    publish(JSON.generate({
      agent_id: attributes["agent_id"],
      name: "File #{attributes["name"]}",
      data: attributes["data"]
    }), to_queue: "worker.events")

    fingerprint = attributes["fingerprint"]
    disposition = Disposition.find_by(fingerprint: fingerprint)

    if disposition.nil?
      # publish command to fetch file from agent
      #publish(JSON.generate({
        #command: :request_analysis,
        #agent_id: attributes["agent_id"],
        #fingerprint: fingerprint,
      #}), to_queue: "worker.commands")
    end

    ack!
  end
end
