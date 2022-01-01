module Dorsum
  module Commands
    class Capabilities
      getter client : Dorsum::Client

      def initialize(@client)
      end

      def run
        Log.info { "Registering capabilites with the server…" }
        client.puts("CAP REQ :twitch.tv/membership")
        client.puts("CAP REQ :twitch.tv/tags")
        client.puts("CAP REQ :twitch.tv/commands")
      end
    end
  end
end
