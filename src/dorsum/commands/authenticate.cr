require "time"
require "log"

module Dorsum
  module Commands
    class Authenticate
      TIMEOUT = Time::Span.new(seconds: 60)

      getter client : Dorsum::Connection
      getter config : Dorsum::Config

      def initialize(@client, @config)
        @started_at = Time.monotonic
        @finished = false
      end

      def start
        Log.info { "Sending password and username to server…" }
        client.puts("PASS #{config.password}")
        client.puts("NICK #{config.username}")
      end

      def test
        raise Dorsum::TimeoutError.new if timeout?
      end

      def timeout?
        return false if @finished

        (@started_at + TIMEOUT) < Time.monotonic
      end

      def finish
        @finished = true
      end
    end
  end
end
