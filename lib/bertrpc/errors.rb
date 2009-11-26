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

  # Raised when we don't get a response from a server in a timely
  # manner. This typically occurs in spite of a successful connection.
  class ReadTimeoutError < BERTRPCError
    attr_reader :host, :port, :timeout
    def initialize(host, port, timeout)
      @host, @port, @timeout = host, port, timeout
      super("No response from #{host}:#{port} in #{timeout}s")
    end
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
