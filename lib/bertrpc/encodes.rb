module BERTRPC
  module Encodes
    def encode_ruby_request(ruby_request)
      BERT.encode(ruby_request)
    end

    def decode_bert_response(bert_response)
      ruby_response = BERT.decode(bert_response)
      case ruby_response[0]
        when :reply
          ruby_response[1]
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
  end
end