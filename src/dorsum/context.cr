require "json"

module Dorsum
  # Keeps the details of how the CLI tool was called.
  class Context
    property errors : Array(String)
    property command : String
    property channel : String
    property? run
    property? verbose

    def initialize
      @errors = [] of String
      @command = "run"
      @channel = ""
      @run = true
      @verbose = false
    end
  end
end
