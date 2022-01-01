require "log"

module Dorsum
  class Controller
    property client : Dorsum::Client
    property config : Dorsum::Config
    property context : Dorsum::Context

    def initialize(@client, @config, @context)
    end

    def run
      hype = Dorsum::Commands::Hype.new(client)
      Dorsum::Commands::Authenticate.new(client, config).run
      loop do
        line = client.gets
        if line
          message = Message.new(line)
          case message.command
          when "001"
            Dorsum::Commands::Capabilities.new(client).run
            Dorsum::Commands::Join.new(client, context).run
          when /\A\d{3}\Z/
          when "CAP"
          when "CLEARCHAT"
            if message.message == config.username
              Log.info { "Exiting because we were timed out." }
              exit
            end
          when "JOIN"
            if message.source && message.source.as(String).starts_with?(":#{config.username}!")
              Log.info { "Joined #{message.arguments}!" }
            end
          when "PING"
            client.puts("PONG #{message.message}")
          when "PRIVMSG"
            Log.info { "\e[38;5;#{message.ansi_code}m#{message.badge} #{message.display_name}:\e[0m #{message.message}" }
            hype.run(message)
          when "RECONNECT"
            Log.warn { "Server asked us to reconnect" }
            return
          when "ROOMSTATE"
          when "USERSTATE"
          else
            Log.info { "Not implemented: #{message.command}" }
          end
        end
      end
    end
  end
end
