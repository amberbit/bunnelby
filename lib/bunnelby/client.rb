class Bunnelby::Client
  class CommunicationError < StandardError; end

  include Bunnelby::Logger

  def initialize(channel, server_queue)
    @_server_queue = server_queue
    @_channel = channel
    @_exchange = @_channel.default_exchange
    @_reply_queue = @_channel.queue("", :exclusive => true)
    @_lock      = Mutex.new
    @_condition = ConditionVariable.new
  end

  def response
    @_response
  end

  def response=(response)
    @_response = response
  end

  def lock
    @_lock
  end

  def condition
    @_condition
  end

  def call_id
    @_call_id
  end

  private

  def do_call(command, arguments, timeout_in_sec = 0)
    do_subscribe

    @_call_id = SecureRandom.uuid

    @_exchange.publish({command: command, arguments: arguments}.to_json,
                       routing_key: @_server_queue,
                       correlation_id: call_id,
                       reply_to: @_reply_queue.name)

    @_lock.synchronize{condition.wait(@_lock, timeout_in_sec)}

    do_unsubscribe

    raise CommunicationError unless response

    JSON.parse(response)
  end

  def do_send(command, arguments)
    @_exchange.publish({command: command, arguments: arguments}.to_json,
                       routing_key: @_server_queue)

  end

  def do_subscribe
    that = self

    @_consumer = @_reply_queue.subscribe do |delivery_info, properties, payload|
      if properties[:correlation_id] == that.call_id
        log "#{self.class.to_s} received RPC response:"
        log payload

        that.response = payload
        that.lock.synchronize{that.condition.signal}
      end
    end
  end

  def do_unsubscribe
    @_consumer.cancel
  end
end

