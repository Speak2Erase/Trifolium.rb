#! ど  (’. ,  ７
require_relative "log"

class Sender
  def initialize(client)
    @client = client
  end

  def send(message)
    return unless @client.connected?
    begin
      self.send_unsafe(message)
    rescue Exception => e
      Log.log("Client send error: #{e}", Log::Types::ERROR)
    end
  end

  def send_unsafe(message)
    @client.socket.send("#{message}\n", 0)
    Log.log("Outgoing message: #{message}", Log::Types::SendInfo)
  end

  def send_to_clients(clients, message)
    clients.each do |client|
      client.sender.send(message)
    end
  end

  def send_to_all(message, including_self = false)
    send_to_clients(@client.handler.clients(
      if including_self
        @client
      end
    ), message)
  end

  def send_to_map(message, including_self = false)
    send_to_clients(@client.handler.on_map(@client, including_self), message)
  end
end
