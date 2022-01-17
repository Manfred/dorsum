require "spec"
require "../../src/dorsum"

module Dorsum
  class MockClient < Dorsum::Connection
    property _messages : Array(String)

    def initialize
      @_messages = [] of String
    end

    def gets
      ""
    end

    def puts(data : String)
      self._messages << data
    end
  end
end

require "webmock"

WebMock.stub(:post, %r{\Ahttps://id.twitch.tv/oauth2/token}).to_return(
  status: 200,
  body: {
    "access_token" => "xxx",
    "expires_in"   => 0,
  }.to_json
)
