class Client
    def try_buddy(username)
        client = db["users", "username", username].first
        return Result::PLAYER_NOT_EXIST unless client

        client = @handler.by_name(username)
        return Result::PLAYER_NOT_ONLINE unless client
        return Result::PLAYER_NOT_ON_MAP unless client.player.map_id == @player.map_id

        if client.needs_confirming?(:buddies, self)
            client.confirm(:buddies, self)
        else
            client.add_confirmation(:buddies, self, proc {
                db.insert("buddy_list", {
                    "user1_id" => client.player.user_id,
                    "user2_id" => @player.user_id
                })

                tell(Messages::BUDDYADD, username)
                @player.buddies << username
                client.tell(Messages::BUDDYADD, @player.username)
                client.player.buddies << @player.username
            })
        end
        return Result::SUCCESS
    end

    def visit_buddyadd(msg)
        result = try_buddy(msg.username)

        process_result(result)
    end
end