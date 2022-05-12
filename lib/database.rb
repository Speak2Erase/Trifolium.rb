require "concurrent-ruby"
require "sqlite3"

module SQLite3
  class Database
    alias o_execute execute

    def execute(*args)
      Log.log("SQL Request: #{args.join(", ")}", Log::Types::SqlInfo)
      o_execute(*args)
    end
  end
end

class Database
  TABLES = {
    "users" => [
      "user_id",
      "username",
      "password",
      "usergroup",
      "banned",
      "token",
    ],
    "ips" => [
      "user_id",
      "ip",
    ],
    "guilds" => [
      "guild_id",
      "guild_name",
      "leader_id",
      "password",
    ],
    "user_data" => [
      "user_id",
      "lastlogin",
      "guild_id",
    ],
    "buddy_list" => [
      "user1_id",
      "user2_id",
    ],
    "inbox" => [
      "pm_id",
      "recipient_id",
      "sender_name",
      "send_date",
      "message",
      "unread",
    ],
    "save_data" => [
      "user_id",
      "data_name",
      "data_value",
    ],
  }

  def initialize
    @db = SQLite3::Database.new "db/database.db"
    @db.results_as_hash = true
    Log.log("Database opened", Log::Types::DatabaseInfo)
  end

  def [](from, where, what, qand = {}, qor = {})
    req = "SELECT "
    req += TABLES[from].join(", ")
    req += " FROM #{from}"
    req += " WHERE #{where}"
    req += " = '#{what}'"
    qand.each do |key, value|
      req += " AND #{key} = '#{value}'"
    end
    qor.each do |key, value|
      req += " OR #{key} = '#{value}'"
    end
    @db.execute(req)
  end

  def []=(from, where, what, to, value)
    req = "UPDATE #{from}"
    req += " SET #{to} = '#{value}'"
    req += " WHERE #{where} = '#{what}'"
    @db.execute(req)
  end

  def delete(from, where, what)
    req = "DELETE FROM #{from} WHERE #{where} = '#{what}'"
    @db.execute(req)
  end

  def insert(into, what = {})
    @db.execute("INSERT INTO #{into} (#{what.keys.join(", ")}) VALUES (#{what.values.map { |s|
      if s.is_a?(String)
        "'#{s}'"
      else
        s
      end
    }.join(", ")})")
  end

  def replace(into, what = {})
    @db.execute("REPLACE INTO #{into} (#{what.keys.join(", ")}) VALUES (#{what.values.map { |s|
      if s.is_a?(String)
        "'#{s}'"
      else
        s
      end
    }.join(", ")})")
  end

  def execute(req)
    warn "DB.execute: #{req} should NOT be used. This is an UNABSTRACTED temporary method."
    @db.execute(req)
  end

  def begin
    @db.execute("BEGIN TRANSACTION")
  end

  def end
    @db.execute("COMMIT TRANSACTION")
  end

  def close
  end
end
