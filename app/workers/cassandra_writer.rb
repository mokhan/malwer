class CassandraWriter
  include Sneakers::Worker
  from_queue "worker.events"

  def work(event_json)
    ack!
  end
end
