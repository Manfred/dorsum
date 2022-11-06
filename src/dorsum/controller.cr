require "log"

module Dorsum
  class Controller
    property client : Dorsum::Client
    property api : Dorsum::Api::Client
    property config : Dorsum::Config
    property context : Dorsum::Context

    property authenticate : Dorsum::Commands::Authenticate
    property ping : Dorsum::Commands::Ping

    def initialize(@client, @api, @config, @context)
      @authenticate = Dorsum::Commands::Authenticate.new(@client, @config)
      @ping = Dorsum::Commands::Ping.new(client)
    end

    def run
      handle_authentication
      listen(fetch_broadcaster_id)
    end

    def handle_authentication
      authenticate.start
      loop do
        begin
          line = client.gets
        rescue e : IO::TimeoutError
          Log.debug { "T: #{e.message}" }
          next
        end
        if line
          message = Message.new(line)
          handle_message(message, nil)
          return
        end
      end
    end

    def fetch_broadcaster_id
      broadcaster_id = api.broadcaster_id(context.channel)
      exit unless broadcaster_id
      broadcaster_id
    end

    def listen(broadcaster_id)
      title = Dorsum::Commands::Title.new(client, api, broadcaster_id)
      loop do
        begin
          line = client.gets
        rescue e : IO::TimeoutError
          Log.debug { "T: #{e.message}" }
          next
        end
        if line
          message = Message.new(line)
          handle_message(message, title)
        end
      end
    end

    def handle_message(message, title : (Dorsum::Commands::Title | Nil))
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
        title.as(Dorsum::Commands::Title).run(message) if title
      when "RECONNECT"
        Log.warn { "Server asked us to reconnect" }
        raise ReconnectError.new("Server asked us to reconnect")
      when "CLEARMSG"
        Log.info do
          content = message.message ? ": #{message.message}" : ""
          "࿏ \e[38;5;65m#{message.login}\e[0m#{content}\e[0m"
        end
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
