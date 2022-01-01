require "yaml"

module Dorsum
  class Config
    PATH = Path["~/.dorsum.yml"].expand(home: true)

    property data : Hash(String, YAML::Any)

    def initialize
      @data = {} of String => YAML::Any
    end

    def initialize(data : YAML::Any)
      @data = {} of String => YAML::Any
      %w[username password].each do |attribute|
        value = data[attribute]?
        @data[attribute] = value if value
      end
    end

    def username
      @data["username"]
    end

    def username=(username : String)
      @data["username"] = YAML::Any.new(username)
    end

    def password
      @data["password"]
    end

    def password=(password : String)
      @data["password"] = YAML::Any.new(password)
    end

    def save(path = PATH)
      File.open(path, "wb") { |file| file << YAML.dump(data) }
    end

    def self.load(path = PATH)
      if File.exists?(path)
        Config.new(YAML.parse(File.read(path)))
      else
        Config.new
      end
    end
  end
end
