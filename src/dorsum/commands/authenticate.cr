require "log"

module Dorsum
  module Commands
    class Authenticate
      getter client : Dorsum::Client
      getter config : Dorsum::Config

      def initialize(@client, @config)
      end

      def run
        Log.info { "Sending password and username to server…" }
        client.puts("PASS #{config.password}")
        client.puts("NICK #{config.username}")
      end
    end
  end
end
