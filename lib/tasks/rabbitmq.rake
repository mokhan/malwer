namespace :rabbitmq do
  desc "setup rabbitmq routing"
  task setup: :environment do
    require "bunny"
    connection = Bunny.new
    connection.start
    channel = connection.create_channel

    # single malwer topic exchange
    # routing keys:
    # * commands.command_type.(agent_id/fingerprint)
      # * commands can be issued for specific agents
      # * commands can be issued globally. (e.g. poke a dispostion)
    # * events.event_type.agent_id

    channel.topic("malwer").tap do |exchange|
      # event intake bindings
      queue = channel.queue("worker.events", durable: true)
      queue.bind(exchange, routing_key: "events.#")

      # poke bindings
      queue = channel.queue("worker.poke", durable: true)
      queue.bind(exchange, routing_key: "commands.poke.#")

      # cloud queries bindings
      queue = channel.queue("worker.queries", durable: true)
      queue.bind(exchange, routing_key: 'events.scanned.#')

      # cassandra worker bindings
      queue = channel.queue("worker.cassandra", durable: true)
      queue.bind(exchange, routing_key: 'events.scanned.#')
    end

    connection.close
  end
end
