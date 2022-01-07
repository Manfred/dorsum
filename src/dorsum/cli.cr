require "log"

module Dorsum
  class Cli
    getter config : Config
    getter context : Context

    def initialize
      @context = Context.new
      @config = Config.load
    end

    def run(argv)
      OptionParser.parse(argv, context, config)
      if context.errors.any?
        print_errors
      elsif context.run?
        run_command
      end
    end

    def run_command
      case context.command
      when "run"
        run_forever
      when "config"
        @config.save
      end
    end

    private def run_forever
      api = Dorsum::Api::Client.new(config)
      loop { run(api) }
    end

    private def run(api : Dorsum::Api::Client)
      client = Dorsum::Client.new
      client.connect
      Dorsum::Controller.new(client, api, config, context).run
    rescue e : IO::TimeoutError
      Log.warn { e.message }
    end

    private def print_errors
      context.errors.each do |error|
        Log.fatal { error }
      end
    end
  end
end
