require "discordrb"
require_relative "../log"

class Bot
  def register_chat_event
    if @config["chat_channel"]
      @bot.clear!
      @bot.message(in: @config["chat_channel"]) do |event|
        next if event.content.empty?
        @server.client_handler.clients.each do |c|
          c.tell_chat(
            Log::Color::INFO,
            "#{event.author.username} | #{event.content}"
          )
        end
      end
    end
  end

  def send_chatmessage(message)
    /\ACHT\t(.{6})\t(.+)\t(.+)/ =~ message
    color = $1
    user_id = $2
    message = $3

    client = @server.client_handler.by_id(user_id.to_i)
    emote = if client.player.usergroup >= 0
      "<:Admin:973762838956998666>"
    else
      "<:Person:973762838994776064>"
    end
    if @config["chat_channel"]
      @bot.send_message(@config["chat_channel"], "#{emote} #{client.player.username} : Map #{client.player.map_id} | #{message}")
    end
  end

  def send_login(username, usergroup)
    emote = if usergroup >= 0
        "<:Admin:973762838956998666>"
      else
        "<:Person:973762838994776064>"
      end
    if @config["chat_channel"]
      @bot.send_message(@config["chat_channel"], "#{emote} #{username} has joined the server.")
    end
  end

  def send_logout(username, usergroup)
    emote = if usergroup >= 0
        "<:Admin:973762838956998666>"
      else
        "<:Person:973762838994776064>"
      end
    if @config["chat_channel"]
      @bot.send_message(@config["chat_channel"], "#{emote} #{username} has left the server.")
    end
  end

  def log_log(message, type)
    if @config["log_channel"]
      const = Object.const_get("Log::LogLevel::#{@config["log_level"]}")
      if const >= type
        @bot.send_message(
          @config["log_channel"],
          "```#{Log::LogLevel::Strings[type] + message}```"
        )
      end
    end
  end
end
