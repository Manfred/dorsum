require "../spec_helper"
require "json"

describe Dorsum::Commands::Title do
  it "responds to the !title command" do
    config = Dorsum::Config.new
    config.client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    config.client_secret = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"

    client = Dorsum::MockClient.new
    api = Dorsum::Api::Client.new(config)
    broadcaster_id = "42"
    title = Dorsum::Commands::Title.new(client, api, broadcaster_id)
    message = Dorsum::Message.new("@display-name=Root;user-type= :root!root@root.tmi.twitch.tv PRIVMSG #channel :!title")

    WebMock.stub(:get, %r{\Ahttps://api.twitch.tv/helix/channels}).to_return(
      status: 200,
      body: {
        "data" => [
          {"id" => 42, "title" => "Happy happy birds!"},
        ],
      }.to_json
    )

    title.run(message)
    client._messages.size.should eq(1)
    client._messages[0].should match(%r{\APRIVMSG #channel :@Root .+ Happy happy birds!\z})
  end
end
