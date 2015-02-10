class Publisher
  def self.publish(message)
    exchange = channel.topic("malwer")
    exchange.publish(message.to_json, routing_key: message.routing_key)
  end

  def self.channel
    @channel ||= connection.create_channel
  end

  def self.connection
    @connection ||= Bunny.new.tap do |connection|
      connection.start
    end
  end
end
