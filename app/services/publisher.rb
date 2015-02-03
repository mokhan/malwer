class Publisher
  def self.publish(exchange, message = {})
    exchange = channel.fanout("malwer.#{exchange}")
    exchange.publish(message.to_json)
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
