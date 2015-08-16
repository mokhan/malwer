class CassandraWriter
  include Sneakers::Worker
  from_queue "worker.cassandra"

  def work(event_json)
    attributes = JSON.parse(event_json)

    Document.create!(
      agent_id: attributes['agent_id'],
      path: attributes['data']['path'],
      filename: File.basename(attributes['data']['path']),
      fingerprint: attributes["data"]["fingerprint"],
    )
    ack!
  end
end
