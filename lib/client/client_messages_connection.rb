require_relative "../messages"
require_relative "../result"
require_relative "../config"

class Client
  def visit_connectionreset(msg)
    result = Result::SUCCESS
    if msg.version.to_f < Config.config["version"].to_f
      update_ip = Config.config["update_server_ip"]
      update_port = Config.config["update_server_port"]
      tell(Messages::UPDATEREDIRECT, update_ip, update_port)
      cut_off
      return
    elsif @handler.clients.size >= Config.config["max_clients"].to_i
      result = Result::DENIED
    end
    tell(Messages::CONNECTIONRESET, result, Config.config["version"], msg.game_version)
  end

  def visit_connectionlogin(msg)
    result = try_login(msg.username, msg.password)
    if result == Result::SUCCESS
      Log.log("Client token #{@player.user_token}", Log::Types::ClientToken)
      tell(Messages::TOKENRESPONSE, @player.user_token)
    else
      Log.log("Client login failed: #{Result::TEXT[result]}", Log::Types::LoginFailed)
    end
    tell(Messages::TOKENRESULT, result)
  end

  def visit_connectiontruelogin(msg)
    result = try_true_login(msg.token)
    if result == Result::SUCCESS
      Log.log("Client token #{@player.user_token}", Log::Types::ClientToken)
      tell(Messages::CONNECTIONTRUELOGIN, @player.get_login_data)
      if @player.guildname
        tell(Messages::GUILDINVITE, @player.get_guild_data)
      end
    else
      Log.log("Client login failed: #{Result::TEXT[result]}", Log::Types::LoginFailed)
    end
    tell(Messages::TOKENRESULT, result)
  end

  def visit_connectionregister(msg)
    code = try_register(msg.username, msg.password)

    if code == Result::SUCCESS
      try_login(msg.username, msg.password)
      tell(Messages::TOKENRESPONSE, @player.user_token)
      tell(Messages::TOKENRESULT, @player.get_login_data)

      if @player.guildname != ""
        tell(Messages::GUILDINVITE, @player.get_guild_data)
      end
    end
    tell(Messages::CONNECTIONREGISTER, code)
  end
end
