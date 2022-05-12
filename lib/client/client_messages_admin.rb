require_relative "../result"
require_relative "../groups"

class Client
  def visit_kickall(_)
    result = get_permission("kickall")

    unless result
      @handler.clients(self).each do |c|
        next if c.player.usergroup >= @player.usergroup
        c.kick
      end
      result = Result::SUCCESS
    end
    process_result(result)
  end

  def try_kick(username)
    result = get_permission("kick")
    return result if result

    client = @handler.by_name(username)
    return Result::PLAYER_NOT_EXIST unless client
    return Result::DENIED_S if client.player.usergroup >= @player.usergroup

    client.kick
    Result::SUCCESS
  end

  def visit_kickplayer(msg)
    result = try_kick(msg.username)

    process_result(result)
  end

  def try_ban(username)
    result = get_permission("ban")
    return result if result

    client = db["users", "username", username].first
    return Result::PLAYER_NOT_EXIST unless client

    return Result::DENIED_S if client["usergroup"] >= @player.usergroup

    db["users", "username", username, "banned"] = 1

    client = @handler.by_name(username)
    client.kick if client

    Result::SUCCESS
  end

  def visit_banplayer(msg)
    result = try_ban(msg.username)

    process_result(result)
  end

  def try_unban(username)
    result = get_permission("unban")
    return result if result

    client = db["users", "username", username].first
    return Result::PLAYER_NOT_EXIST unless client

    return Result::DENIED_S if client["usergroup"] >= @player.usergroup

    db["users", "username", username, "banned"] = 0
    Result::SUCCESS
  end

  def visit_unbanplayer(msg)
    result = try_unban(msg.username)

    process_result(result)
  end

  def try_forced_password_change(username, password)
    result = get_permission("pass")
    return result if result

    client = db["users", "username", username].first
    return Result::PLAYER_NOT_EXIST unless client

    return Result::PASSWORD_SAME if client["password"] == password

    db["users", "username", username, "password"] = password

    return Result::SUCCESS
  end

  def visit_changeplayerpassword(msg)
    result = try_forced_password_change(msg.username, msg.password)

    process_result(result)
  end

  def try_forced_guild_password_change(guildname, password)
    result = get_permission("gpass")
    return result if result

    guild = db["guilds", "guildname", guildname].first
    return Result::GUILD_NOT_EXIST unless guild

    db["guilds", "guildname", guildname, "password"] = password

    return Result::SUCCESS
  end

  def visit_changeguildpassword(msg)
    result = try_forced_guild_password_change(msg.guildname, msg.password)
  end

  def try_group_change(username, usergroup)
    return Result::DENIED if usergroup >= @player.usergroup

    client = db["users", "username", username].first
    return Result::PLAYER_NOT_EXIST unless client
    return Result::DENIED if client["usergroup"] >= @player.usergroup

    db["users", "username", username, "usergroup"] = usergroup

    client = @handler.by_name(username)
    if client
      client.player.usergroup = usergroup

      client.tell(Messages::USERGROUPRESULT, client.player.usergroup)

      client.sender.send_to_clients(
        @handler.clients(client),
        form_message(Messages::PLAYERDATA, client.player.get_player_data)
      )
    end

    return Result::SUCCESS
  end

  def visit_changeplayergroup(msg)
    result = try_group_change(msg.username, msg.group.to_i)

    process_result(result)
  end

  def try_global_chat(message)
    result = get_permission('global')
    return result if result

    @sender.send_to_all(form_message(Messages::CHAT, message), true)
    return Result::SUCCESS
  end

  def visit_globalchat(msg)
    result = try_global_chat(msg.message)

    process_result(result)
  end

  def visit_globaleval(_)
    Log.log("Client called global eval! THIS IS UNSAFE.", Log::Types::DangerousCommand)
    process_result(Result::DENIED_S)
  end

  def visit_sqlreq(_)
    Log.log("Client called sql request! THIS IS UNSAFE.", Log::Types::DangerousCommand)
    process_result(Result::DENIED_S)
  end

  def visit_servereval(_)
    Log.log("Client called server eval! THIS IS UNSAFE.", Log::Types::DangerousCommand)
    process_result(Result::DENIED_S)
  end
end
