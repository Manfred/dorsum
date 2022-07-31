require "../spec_helper"

describe Dorsum::Commands::Authenticate do
  it "will not time out during regular operation" do
    config = Dorsum::Config.new
    config.username = "anderson"
    config.password = "secret"

    client = Dorsum::MockClient.new
    authenticate = Dorsum::Commands::Authenticate.new(client, config)

    authenticate.timeout?.should eq false

    authenticate.start
    authenticate.timeout?.should eq false

    authenticate.test
    authenticate.finish
    authenticate.timeout?.should eq false

    authenticate.test
  end
end
