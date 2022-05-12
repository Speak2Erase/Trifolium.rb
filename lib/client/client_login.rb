require_relative "../result"

class Client
  def try_login(username, password)
    user = db["users", "username", username].first
    return Result::PLAYER_NOT_EXIST if user.nil?
    return Result::PASSWORD_INCORRECT if user["password"] != password
    return Result::DENIED if user["banned"] != 0

    user_id = user["user_id"].to_i
    usergroup = user["usergroup"].to_i
    user_token = user["token"]
    @player.set_user_data(user_id, username, usergroup, user_token)

    client = @handler.by_id(user_id)
    client.disconnect if client

    return Result::SUCCESS
  end

  def try_true_login(token)
    user = db["users", "token", token].first
    return Result::PLAYER_NOT_EXIST if user.nil?
    return Result::DENIED if user["banned"] != 0

    user_id = user["user_id"].to_i
    usergroup = user["usergroup"].to_i
    username = user["username"]

    # IP ban check
    ip = socket.peeraddr[3]
    if db.execute(
      "SELECT DISTINCT users.user_id FROM users JOIN " +
      "ips ON users.user_id = ips.user_id WHERE ips.ip = '#{ip}' AND banned = 1"
    ).length > 0
      return Result::DENIED
    end

    @player.set_user_data(user_id, username, usergroup, token)

    db["user_data", "user_id", user_id, "lastlogin"] = Time.now.to_i

    db.replace("ips", {
      "user_id" => user_id,
      "ip" => ip,
    })

    @player.setup_buddies

    guild_id = db["user_data", "user_id", user_id].first["guild_id"]

    @player.setup_guild_data(guild_id.to_i) if guild_id

    @handler.login self

    return Result::SUCCESS
  end
end
