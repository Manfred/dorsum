require "log"

module Dorsum
  class Controller
    property client : Dorsum::Client
    property api : Dorsum::Api::Client
    property config : Dorsum::Config
    property context : Dorsum::Context

    def initialize(@client, @api, @config, @context)
    end

    def run
      # hype = Dorsum::Commands::Hype.new(client)
      ping = Dorsum::Commands::Ping.new(client)
      Dorsum::Commands::Authenticate.new(client, config).run

      broadcaster_id = api.broadcaster_id(context.channel)
      exit unless broadcaster_id
      title = Dorsum::Commands::Title.new(client, api, broadcaster_id)
      gnome = Dorsum::Commands::Gnome.new(client)

      loop do
        begin
          line = client.gets
        rescue e : IO::TimeoutError
          ping.run
        end
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
          when "NOTICE"
            Log.info { message.message }
          when "PART"
          when "PING"
            client.puts("PONG #{message.message}")
          when "PONG"
          when "PRIVMSG"
            # hype.run(message)
            title.run(message)
            gnome.run(message)
          when "RECONNECT"
            Log.warn { "Server asked us to reconnect" }
            return
          when "ROOMSTATE"
          when "USERSTATE"
          when "USERNOTICE"
            # content = message.message ? ": #{message.message}" : ""
            # Log.info { "\e[38;5;#{message.ansi_code}m#{message.message_id}: #{message.display_name}#{content}\e[0m" }
          else
            Log.info { "Not implemented: #{message.command}" }
          end
        end
      end
    end
  end
end
