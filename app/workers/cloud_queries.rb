require 'json'

class CloudQueries
  include Sneakers::Worker
  from_queue "worker.queries"

  def work(json)
    logger.info "Query for: #{json.inspect}"
    attributes = JSON.parse(json)

    fingerprint = attributes["data"]["fingerprint"]
    disposition = Disposition.find_by(fingerprint: fingerprint)

    Disposition.create!(fingerprint: fingerprint, state: :unknown) if disposition.nil?
    FingerprintLookupJob.perform_later(fingerprint) if disposition.state == :unknown

    ack!
  end
end
