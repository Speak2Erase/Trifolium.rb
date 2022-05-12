require_relative "log"
require_relative "messages"
require "concurrent-ruby"

class ClientHandler
  attr_reader :server

  def initialize(server)
    @clients = []
    @unknown_clients = []
    @server = server
  end

  def add_client(client)
    @unknown_clients << client
    Log.log("Unknown client connected: #{client}", Log::Types::ClientConnect)
    client.async.start
  end

  alias add add_client

  def delete(client)
    index = @clients.index client
    if index
      @clients.delete_at index
      return
    end
    index = @unknown_clients.index client
    if index
      @unknown_clients.delete_at index
      return
    end
    index = @clients.index(client)
    if index
      @clients.delete_at index
      Log.log("Client disconnected: #{client}", Log::Types::ClientDisconnect)
    end

    index = @unknown_clients.index(client)
    if index
      @unknown_clients.delete_at index
      Log.log("Unknown client disconnected: #{client}", Log::Types::ClientDisconnect)
    end

    client.terminate
  end

  def login(client)
    Log.log("Client logged in: #{client}", Log::Types::ClientLogin)
    if Config.config["enable_bot"]
      @server.bot.send_login(client.player.username, client.player.usergroup)
    end
    @unknown_clients.delete client
    @clients << client
  end

  def on_map(current, including_self = false)
    clients = @clients.find_all do |client|
      client.player.map_id == current.player.map_id
    end
    clients.delete current unless including_self
    clients
  end

  def by_id(user_id)
    @clients.find { |client| client.player.user_id == user_id }
  end

  def by_name(username)
    @clients.find { |client| client.player.username == username }
  end

  def clients(current = nil)
    clients = @clients.clone
    clients.delete current if current
    clients
  end

  def start
    @time_start = Time.now
    zombie_counter = 0
    @zombie_task = Concurrent::TimerTask.new(execution_interval: 1) do
      zombie_counter += 1
      @unknown_clients.each do |client|
        client.login_timeout -= Time.now - @time_start
        if client.login_timeout.to_i <= 0
          Log.log("Client timed out: #{client}", Log::Types::ClientPingFailed)
          client.cut_off
          delete client
        elsif zombie_counter % 5 == 0
          begin
            client.sender.send_unsafe(Messages::PING)
          rescue
            Log.log("Client ping failed: #{client}", Log::Types::ClientPingFailed)
            client.cut_off
            delete client
          end
        end
      end
      @clients.each do |client|
        next unless client.zombie
        Log.log("Client zombie: #{client}", Log::Types::CleaningClients)
        delete client
      end
      @time_start = Time.now
    end.execute
    @ping_task = Concurrent::TimerTask.new(execution_interval: 5) do
      @clients.each do |client|
        begin
          client.sender.send_unsafe(Messages::PING)
        rescue
          Log.log("Client ping failed: #{client}", Log::Types::ClientPingFailed)
          client.disconnect
          delete client
        end
      end
    end.execute
  end
end
