module BERTRPC
  class BERTRPCError < StandardError

  end

  class ProtocolError < BERTRPCError

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