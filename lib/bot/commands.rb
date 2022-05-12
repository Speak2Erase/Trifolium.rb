require "discordrb"
require_relative "../groups"

class Bot
  def register_commands
    unless @config["commands_registered"]
      @bot.register_application_command(:list, "Player commands", server_id: @config["command_server_id"])
    end

    register_list
  end

  def register_list
    @bot.application_command(:list) do |event|
      usernames = @server.client_handler.clients.map { |c|
        "#{case c.player.usergroup
        when Groups::ADMIN
          "(ADMIN) "
        when Groups::TWOADMIN
          "(2ND ADMIN) "
        when Groups::MOD
          "(MOD) "
        end}#{c.player.username} : Map #{c.player.map_id}"
      }
      usernames << "Nobody is online... :(" if usernames.empty?

      embed = Discordrb::Webhooks::Embed.new.tap do |e|
        e.title = "Player list"
        e.colour = 0x21faa8
        e.description = "```fix\n#{usernames.join("\n")}```"

        e.footer = Discordrb::Webhooks::EmbedFooter.new.tap do |f|
          f.text = "Requested by #{event.user.username}"
          f.icon_url = event.user.avatar_url
        end
      end

      event.respond(embeds: [embed])
    end
  end
end
