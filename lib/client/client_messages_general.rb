require_relative "../messages"
require "json"

class Client
  def visit_blank(_)
  end

  alias visit_hello visit_blank
  alias visit_ping visit_blank
  alias visit_saveend visit_blank

  def visit_disconnect(_)
    disconnect()
  end

  def visit_chat(msg)
    @sender.send_to_map(msg.string, true)

    if Config.config["enable_bot"]
      @handler.server.bot.send_chatmessage(msg.string)
    end
  end

  alias visit_chataction visit_chat

  def visit_serverentry(msg)
    clients = @handler.clients(self)
    clients.each do |client|
      tell(Messages::PLAYERDATA, client.player.get_player_data)
    end
    @sender.send_to_clients(
      clients,
      form_message(Messages::SERVERENTRY, @player.get_player_data)
    )
  end

  def visit_mapentry(msg)
    @player.map_id = msg.map_id.to_i
    clients = @handler.on_map(self)
    clients.each do |client|
      tell(Messages::MAPENTRY, client.player.get_all_data)
    end
    @sender.send_to_clients(
      clients, form_message(Messages::MAPENTRY, @player.get_all_data)
    )

    tell(Messages::MAPENTRYFINISHED)
  end

  def visit_mapexit(msg)
    @sender.send_to_map(form_message(Messages::MAPEXIT, @player.user_id))
    @player.map_id = 0
  end

  def visit_mapexchangevars(msg)
    variables = JSON.load(msg.vars.gsub(/=>/, ":").gsub(/nil/, "null"))
    @player.evaluate(variables)
    @sender.send_to_map(
      form_message(Messages::MAPEXCHANGEVARS, @player.get_player_data, variables.inspect)
    )
  end

  def visit_playermove(msg)
    @sender.send_to_map(msg.string)
  end

  def visit_warpposition(msg)
    @sender.send_to_map(msg.string)
  end
end
