module BERTRPC
  module Encodes
    def encode_ruby_request(ruby_request)
      ruby_payload = convert(ruby_request)
      Erlectricity::Encoder.encode(ruby_payload)
    end

    def decode_bert_response(bert_response)
      ruby_response = Erlectricity::Decoder.decode(bert_response)
      case ruby_response[0]
        when :reply
          deconvert(ruby_response[1])
        when :noreply
          nil
        when :error
          error(ruby_response[1])
        else
          raise
      end
    end

    def error(err)
      level, code, klass, message, backtrace = err

      case level
        when :protocol
          raise ProtocolError.new([code, message], klass, backtrace)
        when :server
          raise ServerError.new([code, message], klass, backtrace)
        when :user
          raise UserError.new([code, message], klass, backtrace)
        when :proxy
          raise ProxyError.new([code, message], klass, backtrace)
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