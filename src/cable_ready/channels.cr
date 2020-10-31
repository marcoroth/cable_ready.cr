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
  end
end
