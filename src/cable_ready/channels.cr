require "./channel"

module CableReady
  class Channels
    INSTANCE = new

    def self.instance
      INSTANCE
    end

    def initialize
      @channels = {} of String => CableReady::Channel
    end

    def [](identifier)
      @channels[identifier] ||= CableReady::Channel.new(identifier)
    end

    def broadcast
      @channels.each do |_, channel|
        channel.broadcast
      end
    end
  end
end
