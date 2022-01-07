require "log"
require "time"

module Dorsum
  module Commands
    class Hype
      getter client : Dorsum::Client
      getter log : Hash(String, Array(Time::Span))

      HYPERS = %w[
        Clap
        D:
        OMEGALUL
        OOOO
        Peepo
        PoroSad
        horseCrungo
        ratJAM
      ]
      HYPE      = Time::Span.new(seconds: 20)
      COOLDOWN  = Time::Span.new(seconds: 60)
      THRESHOLD = 3

      def initialize(@client)
        @log = {} of String => Array(Time::Span)
        @last = Time.monotonic
      end

      def run(message : Dorsum::Message)
        return unless message.message

        content = message.message.as(String)
        HYPERS.each do |emote|
          if content.includes?(emote)
            remember(emote)
          end
          if hyped?(emote) && calm?
            Log.info { "Hypers! #{emote}" }
            client.puts("PRIVMSG #{message.arguments} :#{emote}")
          end
        end
      end

      private def remember(emote : String)
        unless @log[emote]?
          @log[emote] = [] of Time::Span
        end
        @log[emote].reject! { |time| !recent?(time) }
        @log[emote] << Time.monotonic
      end

      private def hyped?(emote : String)
        if @log[emote]?
          @log[emote].count { |time| recent?(time) } > THRESHOLD
        else
          false
        end
      end

      private def recent?(time : Time::Span)
        (Time.monotonic - time) < HYPE
      end

      private def calm?
        if (Time.monotonic - @last) > COOLDOWN
          @last = Time.monotonic
          true
        else
          false
        end
      end
    end
  end
end
