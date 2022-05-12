require "discordrb"
require "json"
require_relative "log"
require "concurrent-ruby"

Dir.children("lib/bot").each do |file|
  next unless file.end_with?(".rb")
  require_relative "bot/#{file}"
end

class Bot
  include Concurrent::Async

  def initialize(server)
    @config = JSON.load(File.read("lib/bot/config.json"))
    @bot = Discordrb::Bot.new(token: @config["token"], intents: [:server_messages])
    @server = server

    register_chat_event
    unless @config["commands_registered"]
      register_commands
    end

    if @config["chat_channel"]
      @bot.send_message(@config["chat_channel"], "<:Server:973762839108010044> __Server running!__")
    end

    Log.add_subscriber(proc { |message, type|
      next
      async.log_log(message, type)
    })
  end

  def start
    @bot.run(true)
  end

  def close
    if @config["chat_channel"]
      @bot.send_message(@config["chat_channel"], "<:Server:973762839108010044> __Server shutting down...__")
    end
    @bot.stop
  end
end
