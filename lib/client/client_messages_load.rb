class Client
  def visit_saveclear(_)
    db.delete("save_data", "user_id", @player.user_id)
  end

  def visit_savedata(msg)
    db.replace("save_data", {
      "user_id" => @player.user_id,
      "data_name" => msg.key,
      "data_value" => msg.value,
    })
  end

  def visit_loadrequest(_)
    load_data = db["save_data", "user_id", @player.user_id]
    tell(Messages::LOADDATASIZE, load_data.size)
    load_data.each do |data|
      tell(Messages::LOADDATA, data["data_name"], data["data_value"])
    end
    tell(Messages::LOADEND)
  end
end
