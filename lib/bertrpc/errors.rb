module BERTRPC
  class BERTRPCError < StandardError
    attr_accessor :code, :original_exception

    def initialize(msg = nil, klass = nil, bt = [])
      case msg
        when Array
          code, message = msg
        else
          code, message = [0, msg]
      end

      if klass
        self.original_exception = RemoteError.new("#{klass}: #{message}")
        self.original_exception.set_backtrace(bt)
      end

      self.code = code
      super(message)
    end
  end

  class RemoteError < StandardError

  end

  class ConnectionError < BERTRPCError

  end

  class ReadTimeoutError < BERTRPCError

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