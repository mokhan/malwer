namespace :rabbitmq do
  desc "setup rabbitmq routing"
  task setup: :environment do
    require "bunny"
    connection = Bunny.new
    connection.start
    channel = connection.create_channel

    # event intake bindings
    exchange = channel.fanout("malwer.events")
    queue = channel.queue("worker.events", durable: true)
    queue.bind("malwer.events")

    # poke bindings
    exchange = channel.fanout("malwer.poke")
    queue = channel.queue("worker.poke", durable: true)
    queue.bind("malwer.poke")

    # cloud queries bindings
    exchange = channel.fanout("malwer.queries")
    queue = channel.queue("worker.queries", durable: true)
    queue.bind("malwer.queries")

    connection.close
  end
end
