require "log"
require "time"

module Dorsum
  module Commands
    class Gnome
      COOLDOWN = Time::Span.new(seconds: 90)
      MOTES    = %w[crikGnome]

      getter client : Dorsum::Connection
      getter last : Time::Span

      def initialize(@client)
        @last = Time.monotonic - COOLDOWN
      end

      def run(message)
        return unless message.message

        content = message.message.as(String)
        if content.starts_with?("!gnome")
          return if cooldown?

          mote = MOTES.sample
          client.puts("PRIVMSG #{message.arguments} :@#{message.display_name} #{mote}")
        end
      end

      private def since
        Time.monotonic - last
      end

      private def on_cooldown?
        since < COOLDOWN
      end

      private def cooldown?
        if on_cooldown?
          Log.info { "Cooldown #{Dorsum::Message.formatted_time_span(since)}" }
          true
        else
          @last = Time.monotonic
          false
        end
      end
    end
  end
end
