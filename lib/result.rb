require_relative "log"

module Result
  SUCCESS = 0
  DENIED = 1
  DENIED_S = 2
  SERVER_VERSION_MISMATCH = 3
  GAME_VERSION_MISMATCH = 4
  IGNORE = 5

  WAIT_ACTION = 11
  NO_ACTION = 12
  NO_ACTION_ID = 13

  PASSWORD_INCORRECT = 21
  ACCOUNT_ALREADY_EXIST = 22
  PASSWORD_SAME = 23

  PLAYER_NOT_EXIST = 31
  PLAYER_NOT_ONLINE = 32
  PLAYER_NOT_ON_MAP = 33
  PLAYER_ALREADY_IN_GUILD = 34

  GUILD_NOT_EXIST = 41
  GUILD_ALREADY_EXIST = 42

  PM_INBOX_EMPTY = 51
  PM_INBOX_FULL = 52
  PM_UNREAD = 53
  PM_UNREAD_ALL = 54
  PM_NOT_EXIST = 55

  RUBY_INVALID_SYNTAX = 61
  RUBY_SCRIPT_ERROR = 62

  SQL_SCRIPT_ERROR = 71

  TOKEN_INCORRECT = 90

  TEXT = {
    SUCCESS => "Success.",
    DENIED => "Denied.",
    DENIED_S => "You are not allowed to do that!",
    SERVER_VERSION_MISMATCH => "Unmatched client/server version.",
    GAME_VERSION_MISMATCH => "Unmatched client/server version.",
    IGNORE => "Ignore.",
    WAIT_ACTION => "Waiting action.",
    NO_ACTION => "No.",
    NO_ACTION_ID => "No action ID found.",
    PASSWORD_INCORRECT => "Wrong password.",
    ACCOUNT_ALREADY_EXIST => "account already exists.",
    PLAYER_NOT_EXIST => "Player does not exist.",
    PLAYER_NOT_ONLINE => "Player is not online.",
    PLAYER_NOT_ON_MAP => "Player is not on same map.",
    GUILD_NOT_EXIST => "Nonexistent guild.",
    GUILD_ALREADY_EXIST => "Guild already exists.",
    PM_INBOX_EMPTY => "Inbox empty.",
    PM_INBOX_FULL => "Inbox full.",
    PM_UNREAD => "Unread messages.",
    PM_UNREAD_ALL => "All unread messages.",
    RUBY_INVALID_SYNTAX => "Syntax error.",
    RUBY_SCRIPT_ERROR => "Script error.",
    SQL_SCRIPT_ERROR => "THIS SHOULD NEVER SHOW!",
    TOKEN_INCORRECT => "Incorrect token.",
    PASSWORD_SAME => "Password is the same."
  }

  COLORS = {
    SUCCESS => Log::Color::INFO,
    DENIED => Log::Color::ERROR,
    DENIED_S => Log::Color::ERROR,
    SERVER_VERSION_MISMATCH => Log::Color::ERROR,
    GAME_VERSION_MISMATCH => Log::Color::ERROR,
    IGNORE => Log::Color::INFO,
    WAIT_ACTION => Log::Color::INFO,
    NO_ACTION => Log::Color::INFO,
    NO_ACTION_ID => Log::Color::INFO,
    PASSWORD_INCORRECT => Log::Color::ERROR,
    ACCOUNT_ALREADY_EXIST => Log::Color::ERROR,
    PLAYER_NOT_EXIST => Log::Color::ERROR,
    PLAYER_NOT_ONLINE => Log::Color::ERROR,
    PLAYER_NOT_ON_MAP => Log::Color::ERROR,
    GUILD_NOT_EXIST => Log::Color::ERROR,
    GUILD_ALREADY_EXIST => Log::Color::ERROR,
    PM_INBOX_EMPTY => Log::Color::INFO,
    PM_INBOX_FULL => Log::Color::ERROR,
    PM_UNREAD => Log::Color::INFO,
    PM_UNREAD_ALL => Log::Color::INFO,
    RUBY_INVALID_SYNTAX => Log::Color::ERROR,
    RUBY_SCRIPT_ERROR => Log::Color::ERROR,
    SQL_SCRIPT_ERROR => Log::Color::ERROR,
    TOKEN_INCORRECT => Log::Color::ERROR,
    PASSWORD_SAME => Log::Color::ERROR
  }
end
