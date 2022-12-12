require "log"
require "time"

module Dorsum
  module Commands
    class Ping
      THRESHOLD = Time::Span.new(seconds: 60)

      getter client : Dorsum::Client

      def initialize(@client)
        @last = Time.monotonic
        @counter = 0
      end

      def run
        if (Time.monotonic - @last) > THRESHOLD
          @last = Time.monotonic
          @counter += 1
          client.puts("PING #{@counter}")
        end
      end
    end
  end
end
