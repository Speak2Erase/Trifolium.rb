require_relative "log"
require_relative "config"
require_relative "database"
require_relative "client_handler"
require_relative "client"
require_relative "bot"
require "socket"

class Server
  attr_reader :db, :client_handler, :bot

  def initialize
    Log.log(
      "Server ip: #{Config.config["ip"]}\nServer port: #{Config.config["port"]}",
      Log::Types::NetworkInfo
    )

    @server = TCPServer.new(Config.config["ip"], Config.config["port"])
    @db = Database.new

    @client_handler = ClientHandler.new(self)
    if Config.config["enable_bot"]
      @bot = Bot.new(self)
    end
  end

  def start
    Log.log("Server starting...", Log::Types::ServerStart)

    @client_handler.start
    if Config.config["enable_bot"]
      @bot.start
    end
    Log.log("Server started successfully", Log::Types::ServerStart)
  end

  def run
    begin
      until @shutdown
        begin
          connection = @server.accept
        rescue IOError
          break
        end
        client = Client.new(connection, @client_handler)
        @client_handler.add_client client
      end
      shutdown unless @shutdown
    rescue Interrupt
      if @tried_quit
        shutdown
      else
        @tried_quit = true
        Log.log("Press Ctrl + C again to quit.", Log::Types::ServerStop)
        retry
      end
    rescue StandardError => e
      Log.log("#{e.inspect}\n#{e.backtrace.join("\n")}", Log::Types::ServerStop)
      shutdown unless @shutdown
    end
  end

  def shutdown
    @shutdown = true
    Log.log("Shutting down...", Log::Types::ServerStop)
    @client_handler.clients.each do |c|
      c.disconnect
    end

    if Config.config["enable_bot"]
      @bot.close rescue nil
    end

    @server.close rescue nil
    @db.close rescue nil
    Log.log("Shut down gracefully.", Log::Types::ServerStop)
  end
end
