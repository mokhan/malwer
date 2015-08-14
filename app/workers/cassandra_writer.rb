class CassandraWriter
  include Sneakers::Worker
  from_queue "worker.cassandra"

  def work(event_json)
    ack!
  end
end
