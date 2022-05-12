require_relative "groups"
require_relative "messages"

class Player
  attr_accessor :user_id
  attr_accessor :username
  attr_accessor :usergroup
  attr_accessor :buddies
  attr_accessor :guildname
  attr_accessor :guildleader
  attr_accessor :guildmembers
  attr_accessor :user_token
  attr_accessor :map_id
  attr_reader :exchange_variables
  
  def initialize(client)
    @client = client
    
    @user_id = -1
    @username = ""
    @usergroup = Groups::PLAYER
    @user_token = ""
    @buddies = []
    
    @map_id = 0
    @exchange_variables = {}
  end
  
  def evaluate(variables)
    @exchange_variables.merge!(variables)
  end
  
  def get_all_data
    form_message(@map_id, get_current_data)
  end
  
  def get_current_data
    form_message(get_player_data, get_exchange_variables)
  end
  
  def get_player_data
    form_message(@user_id, @username, @usergroup, @guildname.inspect)
  end
  
  def get_exchange_variables
    form_message(@exchange_variables.inspect)
  end
  
  def get_movement_data(move_id)
    sym = move_id.to_sym
    map = {
      move_up: 1,
      move_left: 2,
      move_right: 3,
      move_down: 4,
      
      turn_up: 5,
      turn_left: 6,
      turn_right: 7,
      turn_down: 8,
    }
    form_message(@user_id, map[sym])
  end
  
  def get_login_data
    form_message(@user_id, @username, @usergroup, @buddies, @usertoken)
  end
  
  def get_guild_data
    form_message(@guildname, @guildleader, @guildmembers)
  end
  
  def set_user_data(user_id, username, usergroup, user_token)
    @user_id = user_id
    @username = username
    @usergroup = usergroup
    @user_token = user_token
  end
  
  def setup_buddies
    @buddies = []
    
    buddies = @client.db["buddy_list", "user1_id", @user_id, {}, { "user2_id" => @user_id }]
    buddies.each do |buddy|
      if buddy["user2_id"].to_i == @user_id
        @buddies << buddy["user2_id"].to_i
      else
        @buddies << buddy["user1_id"].to_i
      end
    end
    
    @buddies.each_with_index do |buddy_id, index|
      user = @client.db["users", "user_id", buddy_id].first
      @buddies[index] = user["username"]
    end
  end
end
