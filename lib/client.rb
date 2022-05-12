require_relative "log"
require_relative "messages"
require_relative "sender"
require_relative "player"
require_relative "result"
require "concurrent-ruby"

Dir.children("lib/client").each do |file|
  require_relative "client/#{file}"
end

class Client
  include Concurrent::Async

  attr_accessor :login_timeout
  attr_reader :sender
  attr_reader :socket
  attr_reader :handler
  attr_reader :zombie
  attr_reader :player
  attr_reader :confirmations

  def initialize(socket, handler)
    Log.log("Client connected: #{socket.peeraddr}", Log::Types::ClientConnect)
    @socket = socket
    @login_timeout = Config.config["login_timeout"]

    @sender = Sender.new(self)
    @player = Player.new(self)

    @handler = handler
    @zombie = false

    @confirmations = {
      buddies: {},
      trades: {},
    }
  end

  def needs_confirming?(type, client)
    @confirmations[type].include?(client)
  end

  def add_confirmation(type, client, proc)
    @confirmations[type][client] = proc
  end

  def confirm(type, client)
    @confirmations[type][client].call
    @confirmations[type].delete!(client)
  end

  def to_s
    [@player.username, @player.user_id, @player.user_token].to_s
  end

  def db
    @handler.server.db
  end

  def connected?
    !@socket.closed?
  end

  def cut_off(message = "DCS")
    @sender.send(message)
    @socket.close rescue nil
  end

  def disconnect(message = "DCS")
    @sender.send(message)
    @sender.send_to_all(form_message(Messages::DISCONNECT, @player.user_id))
    @socket.close rescue nil
    if Config.config["enable_bot"]
      @handler.server.bot.send_logout(@player.username, @player.usergroup)
    end
  end

  def kick
    disconnect(Messages::KICK)
  end

  def process_result(code)
    unless code == Result::IGNORE
      message = Result::TEXT[code]
      color = Result::COLORS[code]
      tell_chat(color, message)
    end
  end

  def get_permission(command)
    return Result::DENIED_S unless Groups.has_permission?(@player.usergroup, "kick")
  end

  def tell(*args)
    @sender.send(form_message(*args))
  end

  def tell_chat(color, message)
    tell(Messages::CHAT, color, 0, message)
  end

  def start
    buffer = ""
    begin
      while connected?
        begin
          Log.log("Attempting to get message...", Log::Types::ClientMessage)
          buffer += @socket.recv(0xFFFF)
        rescue Exception => e
          Log.log("Client socket failed to read: #{e.inspect}", Log::Types::ClientSocketFailed)
          break
        end

        messages = buffer.split(Messages::NEWLINE, -1)
        buffer = messages.pop

        messages.each do |message|
          Log.log("Client message: #{message}", Log::Types::ClientMessage)

          if !handle(message)
            Log.log("Unhandled client message: #{message}", Log::Types::UnhandledMessage)
          end
        end
      end
    rescue Exception => e
      Log.log("Client failed: #{e.inspect}, #{@socket.inspect}", Log::Types::ClientFailed)
    end

    @socket.close
    @zombie = true
  end

  def handle(message)
    obj = nil
    Messages::MatchTypes.each do |match, type|
      if message =~ match
        obj = type.new(message)
        break
      end
    end

    if obj.nil?
      return false
    end

    begin
      obj.accept(self)
    rescue Exception => e
      Log.log("Client error: #{e} #{e.backtrace.join("\n")}", Log::Types::ClientFailed)
      return false
    end
    return true
  end
end
