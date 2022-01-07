require "option_parser"

module Dorsum
  class OptionParser
    def self.parse(argv, context : Dorsum::Context, config : Dorsum::Config)
      ::OptionParser.parse(argv) do |parser|
        parser.banner = "Usage: dorsum [options]"
        parser.separator ""
        parser.separator "Commands:"

        parser.on("config", "Configure username and access token.") do
          context.command = "config"
          parser.on("--username USERNAME", "Username used to login to chat.") do |username|
            if username.empty?
              context.errors << "Please specify a username."
            else
              config.username = username
            end
          end
          parser.on("--password PASSWORD", "Password used to login to chat.") do |password|
            if password.empty?
              context.errors << "Please specify a password."
            else
              config.password = password
            end
          end
          parser.on("--client-id CLIENT-ID", "Twitch application client ID") do |client_id|
            if client_id.empty?
              context.errors << "Please specify a Twitch application client ID."
            else
              config.client_id = client_id
            end
          end
          parser.on("--client-secret CLIENT-SECRET", "Twitch application client secret") do |client_id|
            if client_id.empty?
              context.errors << "Please specify a Twitch application client secret."
            else
              config.client_id = client_id
            end
          end
        end

        parser.on("--channel CHANNEL", "Join the channel.") do |channel|
          context.channel = channel
        end

        parser.on("--verbose", "Turn on debug logging.") do
          Log.setup(:debug)
        end

        parser.on("-h", "--help", "Show this help") do
          context.run = false
          puts parser
        end

        parser.missing_option { }
        parser.invalid_option { }
      end
    end
  end
end
