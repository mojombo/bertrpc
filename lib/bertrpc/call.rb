module BERTRPC
  class Call
    include Encodes
    
    def initialize(svc, mod, fun, args)
      @svc = svc
      @mod = mod
      @fun = fun
      @args = args
    end

    def execute
      bert_request = encode_ruby_request([:call, @mod, @fun, @args])
      bert_response = sync_request(bert_request)
      decode_bert_response(bert_response)
    end

    #private

    def sync_request(bert_request)
      sock = TCPSocket.new(@svc.host, @svc.port)
      sock.write([bert_request.length].pack("N"))
      sock.write(bert_request)
      lenheader = sock.read(4)
      raise ProtocolError.new("Unable to read length header from server.") unless lenheader
      len = lenheader.unpack('N').first
      bert_response = sock.read(len)
      raise ProtocolError.new("Unable to read data from server.") unless bert_response
      sock.close
      bert_response
    end
  end
end