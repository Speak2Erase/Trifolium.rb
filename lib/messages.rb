module Messages
  HELLO = "HAI"
  PING = "PNG"
  DISCONNECT = "DCT"
  CHAT = "CHT"
  CHATACTION = "CHA"
  SERVERENTRY = "ENT"
  MAPENTRY = "MEN"
  WARPPOSITION = "WPS"
  MAPEXIT = "MEX"
  MAPEXCHANGEVARS = "MEV"
  PLAYERMOVE = "MOV"
  YES = "YES"
  NO = "NOO"
  CANCEL = "CAN"
  REQUEST = "REQ"
  CONNECTIONRESET = "CON"
  CONNECTIONLOGIN = "LIN"
  CONNECTIONREGISTER = "REG"
  CONNECTIONTRUELOGIN = "TKN"
  KICKALL = "AKA"
  CHANGEPLAYERPASSWORD = "APA"
  CHANGEGUILDPASSWORD = "AGP"
  CHANGEPLAYERGROUP = "GRC"
  GLOBALEVAL = "AEV"
  SERVEREVAL = "SEV"
  SQLREQ = "ASQ"
  KICKPLAYER = "MKI"
  BANPLAYER = "MBA"
  UNBANPLAYER = "MUB"
  GLOBALCHAT = "MGM"
  WHISPHER = "WCH"
  CHANGEPASSWORD = "NPS"
  TRADEREQUEST = "TRQ"
  BUDDYADD = "BAD"
  BUDDYREMOVE = "BRE"
  PMSEND = "PMM"
  PMGETALL = "PMA"
  PMGETUNREAD = "PMU"
  PMOPEN = "PMO"
  PMDELETE = "PMD"
  PMDELETEALL = "PMC"
  PMINBOXSTATUS = "PMS"
  TRADECONFIRM = "TCO"
  TRADEABORT = "TCA"
  TRADEITEMS = "TRI"
  TRADECANCEL = "TRC"
  TRADECONFIRMCANCEL = "TCC"
  TRADEEXECUTE = "TRX"
  GUILDCREATE = "GCR"
  GUILDCHANGEPASSWORD = "GPS"
  GUILDDISBAND = "GDI"
  GUILDTRANSFER = "GTR"
  GUILDINVITE = "GIN"
  GUILDREMOVEMEMBER = "GRE"
  GUILDLEAVE = "GLE"
  GUILDCHAT = "GME"
  SAVECLEAR = "SCL"
  SAVEDATA = "SAV"
  SAVEEND = "SEN"
  LOADREQUEST = "LRQ"
  PLAYERDATA = "PLA"
  MAPENTRYFINISHED = "MEF"
  TOKENRESULT = "TKRS"
  TOKENRESPONSE = "TKR"
  LOADDATASIZE = "LOS"
  LOADDATAMESSAGE = "LOA"
  LOADEND = "LEN"
  KICK = "KCK"
  USERGROUPRESULT = "UGR"
  TRADESTART = "TRS"
  DELIMITER = "\t"
  NEWLINE = "\n"

  class Hello
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_hello(self)
    end
  end

  class Ping
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_ping(self)
    end
  end

  class Disconnect
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_disconnect(self)
    end
  end

  class Chat
    attr_accessor :message
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ACHT\t(.+)/ =~ string
      @message = $1
    end

    def accept(visitor)
      visitor.visit_chat(self)
    end
  end

  class ChatAction
    attr_accessor :action
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ACHA\t(.+)/ =~ string
      @action = $1
    end

    def accept(visitor)
      visitor.visit_chataction(self)
    end
  end

  class ServerEntry
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_serverentry(self)
    end
  end

  class MapEntry
    attr_accessor :map_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AMEN\t(.+)/ =~ string
      @map_id = $1
    end

    def accept(visitor)
      visitor.visit_mapentry(self)
    end
  end

  class WarpPosition
    attr_accessor :ID
    attr_accessor :x
    attr_accessor :y
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AWPS\t(.+)\t(.+)\t(.+)/ =~ string
      @ID = $1
      @x = $2
      @y = $3
    end

    def accept(visitor)
      visitor.visit_warpposition(self)
    end
  end

  class MapExit
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_mapexit(self)
    end
  end

  class MapExchangeVars
    attr_accessor :vars
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AMEV\t(.+)/ =~ string
      @vars = $1
    end

    def accept(visitor)
      visitor.visit_mapexchangevars(self)
    end
  end

  class PlayerMove
    attr_accessor :pid
    attr_accessor :type
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AMOV\t(.+)\t(.+)/ =~ string
      @pid = $1
      @type = $2
    end

    def accept(visitor)
      visitor.visit_playermove(self)
    end
  end

  class Yes
    attr_accessor :action_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AYES\t(.+)/ =~ string
      @action_id = $1
    end

    def accept(visitor)
      visitor.visit_yes(self)
    end
  end

  class No
    attr_accessor :action_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ANOO\t(.+)/ =~ string
      @action_id = $1
    end

    def accept(visitor)
      visitor.visit_no(self)
    end
  end

  class Cancel
    attr_accessor :action_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ACAN\t(.+)/ =~ string
      @action_id = $1
    end

    def accept(visitor)
      visitor.visit_cancel(self)
    end
  end

  class Request
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_request(self)
    end
  end

  class ConnectionReset
    attr_accessor :version
    attr_accessor :game_version
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ACON\t(.+)\t(.+)/ =~ string
      @version = $1
      @game_version = $2
    end

    def accept(visitor)
      visitor.visit_connectionreset(self)
    end
  end

  class ConnectionLogin
    attr_accessor :username
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ALIN\t(.+)\t(.+)/ =~ string
      @username = $1
      @password = $2
    end

    def accept(visitor)
      visitor.visit_connectionlogin(self)
    end
  end

  class ConnectionRegister
    attr_accessor :username
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AREG\t(.+)\t(.+)/ =~ string
      @username = $1
      @password = $2
    end

    def accept(visitor)
      visitor.visit_connectionregister(self)
    end
  end

  class ConnectionTrueLogin
    attr_accessor :token
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ATKN\t(.+)/ =~ string
      @token = $1
    end

    def accept(visitor)
      visitor.visit_connectiontruelogin(self)
    end
  end

  class KickAll
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_kickall(self)
    end
  end

  class ChangePlayerPassword
    attr_accessor :username
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AAPA\t(.+)\t(.+)/ =~ string
      @username = $1
      @password = $2
    end

    def accept(visitor)
      visitor.visit_changeplayerpassword(self)
    end
  end

  class ChangeGuildPassword
    attr_accessor :guildname
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AAGP\t(.+)\t(.+)/ =~ string
      @guildname = $1
      @password = $2
    end

    def accept(visitor)
      visitor.visit_changeguildpassword(self)
    end
  end

  class ChangePlayerGroup
    attr_accessor :username
    attr_accessor :group
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGRC\t(.+)\t(.+)/ =~ string
      @username = $1
      @group = $2
    end

    def accept(visitor)
      visitor.visit_changeplayergroup(self)
    end
  end

  class GlobalEval
    attr_accessor :code
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AAEV\t(.+)/ =~ string
      @code = $1
    end

    def accept(visitor)
      visitor.visit_globaleval(self)
    end
  end

  class ServerEval
    attr_accessor :code
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ASEV\t(.+)/ =~ string
      @code = $1
    end

    def accept(visitor)
      visitor.visit_servereval(self)
    end
  end

  class SQLReq
    attr_accessor :query
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AASQ\t(.+)/ =~ string
      @query = $1
    end

    def accept(visitor)
      visitor.visit_sqlreq(self)
    end
  end

  class KickPlayer
    attr_accessor :username
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AMKI\t(.+)/ =~ string
      @username = $1
    end

    def accept(visitor)
      visitor.visit_kickplayer(self)
    end
  end

  class BanPlayer
    attr_accessor :username
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AMBA\t(.+)/ =~ string
      @username = $1
    end

    def accept(visitor)
      visitor.visit_banplayer(self)
    end
  end

  class UnbanPlayer
    attr_accessor :username
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AMUB\t(.+)/ =~ string
      @username = $1
    end

    def accept(visitor)
      visitor.visit_unbanplayer(self)
    end
  end

  class GlobalChat
    attr_accessor :message
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AMGM\t(.+)/ =~ string
      @message = $1
    end

    def accept(visitor)
      visitor.visit_globalchat(self)
    end
  end

  class Whispher
    attr_accessor :username
    attr_accessor :color
    attr_accessor :user_id
    attr_accessor :message
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AWCH\t(.+)\t(.+)\t(.+)\t(.+)/ =~ string
      @username = $1
      @color = $2
      @user_id = $3
      @message = $4
    end

    def accept(visitor)
      visitor.visit_whispher(self)
    end
  end

  class ChangePassword
    attr_accessor :old_password
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ANPS\t(.+)\t(.+)/ =~ string
      @old_password = $1
      @password = $2
    end

    def accept(visitor)
      visitor.visit_changepassword(self)
    end
  end

  class TradeRequest
    attr_accessor :username
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ATRQ\t(.+)/ =~ string
      @username = $1
    end

    def accept(visitor)
      visitor.visit_traderequest(self)
    end
  end

  class BuddyAdd
    attr_accessor :username
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ABAD\t(.+)/ =~ string
      @username = $1
    end

    def accept(visitor)
      visitor.visit_buddyadd(self)
    end
  end

  class BuddyRemove
    attr_accessor :username
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ABRE\t(.+)/ =~ string
      @username = $1
    end

    def accept(visitor)
      visitor.visit_buddyremove(self)
    end
  end

  class PMSend
    attr_accessor :username
    attr_accessor :message
    attr_accessor :string

    def initialize(string)
      @string = string
      /\APMM\t(.+)\t(.+)/ =~ string
      @username = $1
      @message = $2
    end

    def accept(visitor)
      visitor.visit_pmsend(self)
    end
  end

  class PMGetAll
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_pmgetall(self)
    end
  end

  class PMGetUnread
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_pmgetunread(self)
    end
  end

  class PMOpen
    attr_accessor :pm_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\APMO\t(.+)/ =~ string
      @pm_id = $1
    end

    def accept(visitor)
      visitor.visit_pmopen(self)
    end
  end

  class PMDelete
    attr_accessor :pm_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\APMD\t(.+)/ =~ string
      @pm_id = $1
    end

    def accept(visitor)
      visitor.visit_pmdelete(self)
    end
  end

  class PMDeleteAll
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_pmdeleteall(self)
    end
  end

  class PMInboxStatus
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_pminboxstatus(self)
    end
  end

  class TradeConfirm
    attr_accessor :user_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ATCO\t(.+)/ =~ string
      @user_id = $1
    end

    def accept(visitor)
      visitor.visit_tradeconfirm(self)
    end
  end

  class TradeAbort
    attr_accessor :user_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ATCA\t(.+)/ =~ string
      @user_id = $1
    end

    def accept(visitor)
      visitor.visit_tradeabort(self)
    end
  end

  class TradeItems
    attr_accessor :user_id
    attr_accessor :data
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ATRI\t(.+)\t(.+)/ =~ string
      @user_id = $1
      @data = $2
    end

    def accept(visitor)
      visitor.visit_tradeitems(self)
    end
  end

  class TradeCancel
    attr_accessor :user_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ATRC\t(.+)/ =~ string
      @user_id = $1
    end

    def accept(visitor)
      visitor.visit_tradecancel(self)
    end
  end

  class TradeConfirmCancel
    attr_accessor :user_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ATCC\t(.+)/ =~ string
      @user_id = $1
    end

    def accept(visitor)
      visitor.visit_tradeconfirmcancel(self)
    end
  end

  class TradeExecute
    attr_accessor :user_id
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ATRX\t(.+)/ =~ string
      @user_id = $1
    end

    def accept(visitor)
      visitor.visit_tradeexecute(self)
    end
  end

  class GuildCreate
    attr_accessor :guildname
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGCR\t(.+)\t(.+)/ =~ string
      @guildname = $1
      @password = $2
    end

    def accept(visitor)
      visitor.visit_guildcreate(self)
    end
  end

  class GuildChangePassword
    attr_accessor :oldpass
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGPS\t(.+)\t(.+)/ =~ string
      @oldpass = $1
      @password = $2
    end

    def accept(visitor)
      visitor.visit_guildchangepassword(self)
    end
  end

  class GuildDisband
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGDI\t(.+)/ =~ string
      @password = $1
    end

    def accept(visitor)
      visitor.visit_guilddisband(self)
    end
  end

  class GuildTransfer
    attr_accessor :username
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGTR\t(.+)\t(.+)/ =~ string
      @username = $1
      @password = $2
    end

    def accept(visitor)
      visitor.visit_guildtransfer(self)
    end
  end

  class GuildInvite
    attr_accessor :username
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGIN\t(.+)/ =~ string
      @username = $1
    end

    def accept(visitor)
      visitor.visit_guildinvite(self)
    end
  end

  class GuildRemoveMember
    attr_accessor :username
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGRE\t(.+)/ =~ string
      @username = $1
    end

    def accept(visitor)
      visitor.visit_guildremovemember(self)
    end
  end

  class GuildLeave
    attr_accessor :password
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGLE\t(.+)/ =~ string
      @password = $1
    end

    def accept(visitor)
      visitor.visit_guildleave(self)
    end
  end

  class GuildChat
    attr_accessor :message
    attr_accessor :string

    def initialize(string)
      @string = string
      /\AGME\t(.+)/ =~ string
      @message = $1
    end

    def accept(visitor)
      visitor.visit_guildchat(self)
    end
  end

  class SaveClear
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_saveclear(self)
    end
  end

  class SaveData
    attr_accessor :key
    attr_accessor :value
    attr_accessor :string

    def initialize(string)
      @string = string
      /\ASAV\t(.+)\t(.+)/ =~ string
      @key = $1
      @value = $2
    end

    def accept(visitor)
      visitor.visit_savedata(self)
    end
  end

  class SaveEnd
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_saveend(self)
    end
  end

  class LoadRequest
    attr_accessor :string

    def initialize(string)
      @string = string
    end

    def accept(visitor)
      visitor.visit_loadrequest(self)
    end
  end

  class PlayerData
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_playerdata(self)
    end
  end

  class MapEntryFinished
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_mapentryfinished(self)
    end
  end

  class TokenResult
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_tokenresult(self)
    end
  end

  class TokenResponse
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_tokenresponse(self)
    end
  end

  class LoadDataSize
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_loaddatasize(self)
    end
  end

  class LoadDataMessage
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_loaddatamessage(self)
    end
  end

  class LoadEnd
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_loadend(self)
    end
  end

  class Kick
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_kick(self)
    end
  end

  class UserGroupResult
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_usergroupresult(self)
    end
  end

  class TradeStart
    attr_accessor :string

    def initialize(string)
      raise ArgumentError, "Got a client only message!"
      @string = string
    end

    def accept(visitor)
      visitor.visit_tradestart(self)
    end
  end

  MatchTypes = {
    /\AHAI\Z/ => Hello,
    /\APNG\Z/ => Ping,
    /\ADCT\Z/ => Disconnect,
    /\ACHT\t(.+)/ => Chat,
    /\ACHA\t(.+)/ => ChatAction,
    /\AENT\Z/ => ServerEntry,
    /\AMEN\t(.+)/ => MapEntry,
    /\AWPS\t(.+)\t(.+)\t(.+)/ => WarpPosition,
    /\AMEX\Z/ => MapExit,
    /\AMEV\t(.+)/ => MapExchangeVars,
    /\AMOV\t(.+)\t(.+)/ => PlayerMove,
    /\AYES\t(.+)/ => Yes,
    /\ANOO\t(.+)/ => No,
    /\ACAN\t(.+)/ => Cancel,
    /\AREQ\Z/ => Request,
    /\ACON\t(.+)\t(.+)/ => ConnectionReset,
    /\ALIN\t(.+)\t(.+)/ => ConnectionLogin,
    /\AREG\t(.+)\t(.+)/ => ConnectionRegister,
    /\ATKN\t(.+)/ => ConnectionTrueLogin,
    /\AAKA\Z/ => KickAll,
    /\AAPA\t(.+)\t(.+)/ => ChangePlayerPassword,
    /\AAGP\t(.+)\t(.+)/ => ChangeGuildPassword,
    /\AGRC\t(.+)\t(.+)/ => ChangePlayerGroup,
    /\AAEV\t(.+)/ => GlobalEval,
    /\ASEV\t(.+)/ => ServerEval,
    /\AASQ\t(.+)/ => SQLReq,
    /\AMKI\t(.+)/ => KickPlayer,
    /\AMBA\t(.+)/ => BanPlayer,
    /\AMUB\t(.+)/ => UnbanPlayer,
    /\AMGM\t(.+)/ => GlobalChat,
    /\AWCH\t(.+)\t(.+)\t(.+)\t(.+)/ => Whispher,
    /\ANPS\t(.+)\t(.+)/ => ChangePassword,
    /\ATRQ\t(.+)/ => TradeRequest,
    /\ABAD\t(.+)/ => BuddyAdd,
    /\ABRE\t(.+)/ => BuddyRemove,
    /\APMM\t(.+)\t(.+)/ => PMSend,
    /\APMA\Z/ => PMGetAll,
    /\APMU\Z/ => PMGetUnread,
    /\APMO\t(.+)/ => PMOpen,
    /\APMD\t(.+)/ => PMDelete,
    /\APMC\Z/ => PMDeleteAll,
    /\APMS\Z/ => PMInboxStatus,
    /\ATCO\t(.+)/ => TradeConfirm,
    /\ATCA\t(.+)/ => TradeAbort,
    /\ATRI\t(.+)\t(.+)/ => TradeItems,
    /\ATRC\t(.+)/ => TradeCancel,
    /\ATCC\t(.+)/ => TradeConfirmCancel,
    /\ATRX\t(.+)/ => TradeExecute,
    /\AGCR\t(.+)\t(.+)/ => GuildCreate,
    /\AGPS\t(.+)\t(.+)/ => GuildChangePassword,
    /\AGDI\t(.+)/ => GuildDisband,
    /\AGTR\t(.+)\t(.+)/ => GuildTransfer,
    /\AGIN\t(.+)/ => GuildInvite,
    /\AGRE\t(.+)/ => GuildRemoveMember,
    /\AGLE\t(.+)/ => GuildLeave,
    /\AGME\t(.+)/ => GuildChat,
    /\ASCL\Z/ => SaveClear,
    /\ASAV\t(.+)\t(.+)/ => SaveData,
    /\ASEN\Z/ => SaveEnd,
    /\ALRQ\Z/ => LoadRequest,
    /\APLA\Z/ => PlayerData,
    /\AMEF\Z/ => MapEntryFinished,
    /\ATKRS\Z/ => TokenResult,
    /\ATKR\Z/ => TokenResponse,
    /\ALOS\Z/ => LoadDataSize,
    /\ALOA\Z/ => LoadDataMessage,
    /\ALEN\Z/ => LoadEnd,
    /\AKCK\Z/ => Kick,
    /\AUGR\Z/ => UserGroupResult,
    /\ATRS\Z/ => TradeStart,
  }
end

def form_message(*args)
  args.map { |a| a.to_s }.join(Messages::DELIMITER)
end
