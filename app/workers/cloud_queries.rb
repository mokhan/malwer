require 'json'

class CloudQueries
  include Sneakers::Worker
  from_queue "worker.queries"

  def work(json)
    logger.info "Query for: #{json.inspect}"
    attributes = JSON.parse(json)
    fingerprint = attributes["fingerprint"]
    disposition = Disposition.find_by(fingerprint: fingerprint)
    if disposition.present?
      logger.info("#{disposition.state} disposition for: #{fingerprint}")
    else
      logger.info("Unknown disposition for: #{fingerprint}")
    end

    ack!
  end
end
