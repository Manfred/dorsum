require "log"

module Dorsum
  module Commands
    class Command
      getter client : Dorsum::Client
      getter message : Dorsum::Message

      COMMAND = /\A\!(?<name>[\w]+)/

      def initialize(@client, @message)
      end

      def run
        return unless message.message

        match = message.message.as(String).match(COMMAND)
        if match
          run_command(match["name"])
        end
      end

      private def run_command(command)
        case command
        when "title"
          @client.puts("PRIVMSG #{message.arguments} :PoroSad")
        else
          Log.debug { "Unknown command `#{command}'" }
        end
      end
    end
  end
end
