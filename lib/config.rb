require_relative "log"

module Config
  require "json"
  def self.config; @config; end

  CONFIGS = %w[
    ip
    port
    log_level
    login_timeout
    version
    max_clients
    webhook_url
    webhook_loglevel
    enable_bot
    update_server_ip
    update_server_port
  ]

  def self.load(file)
    @config = JSON.load(File.read(file))
    @config.each do |key, value|
      raise "Unknown config key: #{key.upcase}" unless CONFIGS.include?(key)
    end
  end
end
