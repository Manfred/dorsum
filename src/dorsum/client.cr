require "log"
require "socket"
require "openssl"

module Dorsum
  class Client
    HOST = "irc.chat.twitch.tv"
    PORT = 6697_u16

    def connect
      tcp_socket = TCPSocket.new(HOST, PORT)
      tcp_socket.read_timeout = 120
      tcp_socket.write_timeout = 5
      tcp_socket.keepalive = true
      @socket = OpenSSL::SSL::Socket::Client.new(tcp_socket)
      self
    end

    def socket
      raise "Client is not connected, please call #connect." if @socket.nil?
      @socket.as(OpenSSL::SSL::Socket::Client)
    end

    def gets
      line = socket.gets
      Log.debug { "< #{line}" } if line
      line
    end

    def puts(data)
      line = data.strip
      Log.debug { "> #{line}" }
      socket.puts line
      socket.puts "\r\n"
      socket.flush
    end

    def close
      socket.close
      @socket = nil
    end
  end
end
