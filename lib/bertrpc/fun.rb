module BERTRPC
  class Fun
    def initialize(svc, mod, fun)
      @svc = svc
      @mod = mod
      @fun = fun
    end

    def call(*args)
      args = [*args]
      bert_request = encode_ruby_request([:call, @mod, @fun, args])
      bert_response = sync_request(bert_request)
      decode_bert_response(bert_response)
    end

    # private

    def sync_request(bert_request)
      sock = TCPSocket.new(@svc.host, @svc.port)
      sock.write([bert_request.length].pack("N"))
      sock.write(bert_request)
      len = sock.read(4).unpack('N').first
      bert_response = sock.read(len)
      sock.close
      bert_response
    end

    def encode_ruby_request(ruby_request)
      ruby_payload = convert(ruby_request)
      Erlectricity::Encoder.encode(ruby_payload)
    end

    def decode_bert_response(bert_response)
      ruby_response = Erlectricity::Decoder.decode(bert_response)
      case ruby_response[0]
        when :reply
          deconvert(ruby_response[1])
        when :error
          error(ruby_response[1])
        else
          raise
      end
    end

    def error(err)
      case err[0]
        when :protocol
          raise ProtocolError.new(err[2])
        when :server
          raise ServerError.new(err[2])
        when :user
          raise UserError.new(err[2])
        else
          raise
      end
    end

    def convert(item)
      if item.instance_of?(Hash)
        a = [:dict]
        item.each_pair { |k, v| a << [convert(k), convert(v)] }
        a
      elsif item.instance_of?(Array)
        item.map { |x| convert(x) }
      else
        item
      end
    end

    def deconvert(item)
      if item.instance_of?(Array)
        if item.first == :dict
          item[1..-1].inject({}) do |acc, x|
            acc[deconvert(x[0])] = deconvert(x[1]); acc
          end
        else
          item.map { |x| deconvert(x) }
        end
      else
        item
      end
    end
  end
end