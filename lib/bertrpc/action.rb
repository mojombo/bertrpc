module BERTRPC
  class Action
    include Encodes

    def initialize(svc, req, mod, fun, args)
      @svc = svc
      @req = req
      @mod = mod
      @fun = fun
      @args = args
    end

    def execute
      bert_request = encode_ruby_request([@req.kind, @mod, @fun, @args])
      bert_response = transaction(bert_request)
      decode_bert_response(bert_response)
    end

    #private

    def write(sock, bert)
      sock.write([bert.length].pack("N"))
      sock.write(bert)
    end

    def transaction(bert_request)
      sock = TCPSocket.new(@svc.host, @svc.port)

      if @req.options
        if @req.options[:cache] && @req.options[:cache][0] == :validation
          token = @req.options[:cache][1]
          info_bert = encode_ruby_request([:info, :cache, [:validation, token]])
          write(sock, info_bert)
        end
      end

      write(sock, bert_request)
      lenheader = sock.read(4)
      raise ProtocolError.new("Unable to read length header from server.") unless lenheader
      len = lenheader.unpack('N').first
      bert_response = sock.read(len)
      raise ProtocolError.new("Unable to read data from server.") unless bert_response
      sock.close
      bert_response
    rescue Errno::ECONNREFUSED
      raise ConnectionError.new("Unable to connect to #{@svc.host}:#{@svc.port}")
    end
  end
end