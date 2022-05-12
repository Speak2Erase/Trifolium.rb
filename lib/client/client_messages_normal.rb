class Client
    def try_whisper(username, message)
        client = db["users", "username", username].first

        return Result::PLAYER_NOT_EXIST unless client
        client = @handler.by_name(username)
        return Result::PLAYER_NOT_ONLINE unless client

        client.tell(message)
        tell(message)
        return Result::SUCCESS
    end

    def visit_whisper(msg)
        result = try_whisper(
            msg.username,
            form_message(Messages::CHAT, msg.color, msg.user_id, msg.message)
        )

        process_result(result)
    end

    def try_passwordchange(oldpass, newpass)
        client = db["users", "user_id", @player.user_id].first
        return Result::PASSWORD_INCORRECT if oldpass != client["password"]
        return Result::PASSWORD_SAME if newpass == client["password"]

        db["users", "user_id", @player.user_id, "password"] = password

        return Result::SUCCESS
    end

    def visit_changepassword(msg)
        result = try_passwordchange(msg.old_password, msg.new_password)

        process_result(result)
    end
end