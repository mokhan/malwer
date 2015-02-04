require 'json'

class Poke
  include Sneakers::Worker
  from_queue "worker.poke"

  def work(json)
    attributes = JSON.parse(json)

    disposition = Disposition.find_or_create_by(fingerprint: attributes["fingerprint"])
    disposition.state = attributes["state"]
    disposition.save!

    ack!
  end
end
