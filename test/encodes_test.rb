require 'test_helper'

class EncodesTest < Test::Unit::TestCase
  context "An Encodes includer" do
    setup do
      @enc = Enc.new
    end

    context "ruby request encoder" do
      should "return BERT-RPC encoded request" do
        bert = "\203h\004d\000\004calld\000\005mymodd\000\005myfunl\000\000\000\003a\001a\002a\003j"
        assert_equal bert, @enc.encode_ruby_request(t[:call, :mymod, :myfun, [1, 2, 3]])
      end
    end

    context "bert response decoder" do
      should "return response when reply" do
        req = @enc.encode_ruby_request(t[:reply, [1, 2, 3]])
        res = @enc.decode_bert_response(req)
        assert_equal [1, 2, 3], res
      end

      should "return nil when noreply" do
        req = @enc.encode_ruby_request(t[:noreply])
        res = @enc.decode_bert_response(req)
        assert_equal nil, res
      end

      should "raise a ProtocolError error when protocol level error is returned" do
        req = @enc.encode_ruby_request(t[:error, [:protocol, 1, "class", "invalid", []]])
        assert_raises(BERTRPC::ProtocolError) do
          @enc.decode_bert_response(req)
        end
      end

      should "raise a ServerError error when server level error is returned" do
        req = @enc.encode_ruby_request(t[:error, [:server, 1, "class", "invalid", []]])
        assert_raises(BERTRPC::ServerError) do
          @enc.decode_bert_response(req)
        end
      end

      should "raise a UserError error when user level error is returned" do
        req = @enc.encode_ruby_request([:error, [:user, 1, "class", "invalid", []]])
        assert_raises(BERTRPC::UserError) do
          @enc.decode_bert_response(req)
        end
      end

      should "raise a ProxyError error when proxy level error is returned" do
        req = @enc.encode_ruby_request([:error, [:proxy, 1, "class", "invalid", []]])
        assert_raises(BERTRPC::ProxyError) do
          @enc.decode_bert_response(req)
        end
      end
    end
  end
end