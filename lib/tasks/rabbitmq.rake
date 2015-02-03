namespace :rabbitmq do
  desc "setup rabbitmq routing"
  task setup: :environment do
    require "bunny"
    connection = Bunny.new
    connection.start
    channel = connection.create_channel

    # create exchange
    exchange = channel.fanout("malwer.events")

    # get or create queue (note the durable setting)
    queue = channel.queue("dashboard.events", durable: true)
    # bind queue to exchange
    queue.bind("malwer.events")
    connection.close
  end
end
