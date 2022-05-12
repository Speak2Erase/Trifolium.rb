class Client
    def try_trade(username)
        client = db["users", "username", username].first
        return Result::PLAYER_NOT_EXIST unless client

        client = @handler.by_name(username)
        return Result::PLAYER_NOT_ONLINE unless client
        return Result::PLAYER_NOT_ON_MAP unless client.player.map_id == @player.map_id

        if client.needs_confirming?(:trades, self)
            client.confirm(:trades, self)
        else
            client.add_confirmation(:trades, self, proc {
                tell(Messages::TRADESTART, 0, client.player.user_id)
                client.tell(Messages::TRADESTART, 1, @player.user_id)
            })
        end
        return Result::SUCCESS
    end

    def visit_traderequest(msg)
        result = try_trade(msg.username)

        process_result(result)
    end
end