require "../spec_helper"
require "json"

describe Dorsum::Commands::Gnome do
  it "responds to the !gnome command" do
    config = Dorsum::Config.new
    config.client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    config.client_secret = "zzzzzzzzzzzzzzzzzzzzzzzzzzzzzz"

    client = Dorsum::MockClient.new
    gnome = Dorsum::Commands::Gnome.new(client)
    message = Dorsum::Message.new("@display-name=Root;user-type= :root!root@root.tmi.twitch.tv PRIVMSG #channel :!gnome")

    gnome.run(message)
    client._messages.size.should eq(1)
    client._messages[0].should match(%r{\APRIVMSG #channel :@Root crikGnome\z})
  end
end
