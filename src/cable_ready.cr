require "./cable_ready/channel"
require "./cable_ready/channels"
require "./cable_ready/broadcaster"

require "string_inflection/string/to"
require "string_inflection/case"

module CableReady
  VERSION = "0.1.0"
end


puts Case.camel((:inner_html).to_s).to_s

# puts (:inner_html).to_s.camel.to_sym
