require "json"
require "rufo"
require "sqlite3"

desc "Generate messages"
task :messages do
  f = File.open("lib/messages.rb", "w")
  messages = JSON.load(File.read("messages.json"))
  moduledef = <<~MODULEDEF
                                                                    module Messages

#{messages["messages"].map do |name, message|
    "#{name.upcase} = '#{message["opcode"]}'"
  end.join("\n")}
DELIMITER = "#{messages["delimiter"]}"
NEWLINE = "#{messages["newline"]}"

#{messages["messages"].map do |name, message|
    <<~ClassDef
                                                                                                      class #{name}
#{message["args"].map do |arg|
      "attr_accessor :#{arg}"
    end.join("\n")}
    attr_accessor :string
def initialize(string)
#{if message["client"]
      "raise ArgumentError, 'Got a client only message!'"
    end}
    @string = string
#{unless message["args"].empty?
      <<~ArgDef
#{message_regex(message)} =~ string
#{message["args"].map.with_index do |arg, index|
        "@#{arg} = $#{index + 1}"
      end.join("\n")}
      ArgDef
    else
      ""
    end}
end

def accept(visitor)
  visitor.visit_#{name.downcase}(self)
end
end
ClassDef
  end.join("\n")}

MatchTypes = {
#{messages["messages"].map do |name, message|
    "#{message_regex(message)} => #{name},"
  end.join("\n")}
}
end
def form_message(*args)
  args.map { |a| a.to_s }.join(Messages::DELIMITER)
end
  MODULEDEF
  f.puts Rufo.format(moduledef)
end

def message_regex(message)
  "/\\A#{message["opcode"]}#{if message["args"].empty?
    "\\Z"
  else
    message["args"].map do |arg|
      "\\t(.+)"
    end.join
  end}/"
end

desc "Generate database"
task :db do
  db = SQLite3::Database.new("db/database.db")
  File.read("db/schema.sql").split(/-- .*\n/).each do |sql|
    begin
      db.execute(sql)
    rescue SQLite3::SQLException => e
      puts e.message
      puts sql
      exit
    end
  end
end
