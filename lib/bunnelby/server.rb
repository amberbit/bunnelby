class Bunnelby::Server
  include Bunnelby::Logger

  def initialize(channel, queue_name)
    @channel = channel
    @queue = @channel.queue(queue_name)
    @exchange = @channel.default_exchange
  end

  def start(blocking = true)
    @queue.subscribe(:block => blocking) do |delivery_info, properties, payload|
      log "[#{self.class.to_s}] processing request on '#{@queue.name}':"
      log payload

      message = JSON.parse(payload)
      reply_to = { routing_key: properties.reply_to, correlation_id: properties.correlation_id }

      if allowed_commands.include?(message["command"])
        ActiveRecord::Base.connection_pool.with_connection do
          if reply_to[:correlation_id]
            self.send(message["command"], message["arguments"], reply_to)
          else
            self.send(message["command"], message["arguments"])
          end
        end
      else
        reply({error: "Invalid command: #{message["command"]}"}, reply_to) if reply_to[:correlation_id]
      end
    end
  end

  private

  def reply(data, reply_to)
    @exchange.publish(data.to_json, reply_to)
  end
end

