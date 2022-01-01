module Dorsum
  module Commands
    class Join
      getter client : Dorsum::Client
      getter context : Dorsum::Context

      def initialize(@client, @context)
      end

      def run
        Log.info { "Joining ##{context.channel}…" }
        client.puts("JOIN ##{context.channel}")
      end
    end
  end
end
