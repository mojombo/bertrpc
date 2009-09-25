module BERTRPC
  class BERTRPCError < StandardError
    attr_accessor :code

    def initialize(msg = nil, klass = "Error", bt = [])
      @bt = bt

      case msg
        when Array
          self.code = msg[0]
          super("#{klass}: #{msg[1]}")
        when String
          self.code = 0
          super("#{klass}: #{msg}")
        else
          super("#{klass}: #{msg}")
      end
    end

    def backtrace
      x = super
      x ? ['---REMOTE---'] + @bt + ['---LOCAL---'] + x : x
    end
  end

  class ConnectionError < BERTRPCError

  end

  class ProtocolError < BERTRPCError
    NO_HEADER = [0, "Unable to read length header from server."]
    NO_DATA = [1, "Unable to read data from server."]
  end

  class ServerError < BERTRPCError

  end

  class UserError < BERTRPCError

  end

  class ProxyError < BERTRPCError

  end

  class InvalidOption < BERTRPCError

  end
end