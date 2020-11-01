module CableReady
  class Channel
    property identifier
    property operations

    def initialize(identifier : String)
      @identifier = identifier
      @operations = {} of (String | Symbol) => Array(Hash(Symbol,String))
      reset
    end

    def broadcast()
      operations.select! { |_, list| !list.nil? }

      #FIXME: swap the socket based on the parameters
      # HomeSocket.broadcast("message", "home:xyz", "home", { "message" => { "cableReady" => true, "operations" => operations } })
      reset
    end

    macro method_missing(call)
      def {{call.name.id}}(options : Object)
        add(:{{call.name.id}}, options)
        self
      end
    end

    def add(identifier : Symbol, options : Object)
      if operations.has_key? identifier
        operations[identifier] << options
      else
        operations[identifier] = [options]
      end
    end

    private def reset
      @operations = {} of (String | Symbol) => Array(Hash(Symbol,String))
    end
  end
end
