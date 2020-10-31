# frozen_string_literal: true

require "./channels"

module CableReady
  module Broadcaster
    def cable_ready
      CableReady::Channels.instance
    end
  end
end
