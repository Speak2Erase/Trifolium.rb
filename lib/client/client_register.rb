require "digest"
require_relative "../groups"

class Client
  def try_register(username, password)
    user = db["users", "username", username].first
    return Result::ACCOUNT_ALREADY_EXIST if user

    db.begin

    rndsymbols = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz/\\.@%$!?"
    token_length = 48
    token = ""
    i = 0
    while i < token_length
      randomint = rand(0..rndsymbols.length)
      symbol = rndsymbols[randomint]
      if symbol != nil
        token += symbol
        i += 1
      end
    end
    newtoken = Digest::SHA256.hexdigest token

    db.insert("users", {
      "username" => username,
      "password" => password,
      "usergroup" => Groups::PLAYER,
      "token" => newtoken,
    })

    user = db["users", "username", username].first
    user_id = user["user_id"].to_i

    if user_id == 1
      db["users", "user_id", user_id, "usergroup"] = Groups::ADMIN
    end

    db.insert("user_data", {
      "user_id" => user_id,
      "lastlogin" => Time.now.to_i,
    })

    ip = @socket.peeraddr[3]
    db.replace("ips", {
      "user_id" => user_id,
      "ip" => ip,
    })

    db.end

    return Result::SUCCESS
  end
end
