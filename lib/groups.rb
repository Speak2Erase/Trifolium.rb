module Groups
  ADMIN = 10
  TWOADMIN = 9
  MOD = 8
  PLAYER = 0

  COMMANDS = {
    ADMIN => %w[admin],
    TWOADMIN => %w[kickall mod revoke pass gpass
                   eval geval seval sql],
    MOD => %w[kick ban unban global],
  }

  def self.has_permission?(group, command)
    COMMANDS.keys.each do |g|
      next unless COMMANDS[g].include?(command)
      return group >= g
    end
  end
end
