require 'test_helper'

class EncodesTest < Test::Unit::TestCase
  context "An Encodes includer" do
    setup do
      @enc = Enc.new
    end

    context "converter" do
      should "convert top level hashes to BERT-RPC dict form" do
        arr = @enc.convert({:foo => 1, :bar => 2})
        a = [:dict, [:foo, 1], [:bar, 2]] == arr
        b = [:dict, [:bar, 2], [:foo, 1]] == arr
        assert(a || b)
      end

      should "convert nested hashes in the same way" do
        assert_equal([1, 2, [:dict, [:foo, 1]]], @enc.convert([1, 2, {:foo => 1}]))
      end

      should "keep everything else the same" do
        assert_equal [1, 2, "foo", :bar, 3.14], @enc.convert([1, 2, "foo", :bar, 3.14])
      end
    end

    context "deconverter" do
      should "convert top level BERT-RPC dict forms to hashes" do
        assert_equal({:foo => 1, :bar => 2}, @enc.deconvert([:dict, [:foo, 1], [:bar, 2]]))
      end

      should "convert nested dicts in the same way" do
        assert_equal([1, 2, {:foo => 1}], @enc.deconvert([1, 2, [:dict, [:foo, 1]]]))
      end

      should "keep everything else the same" do
        assert_equal [1, 2, "foo", :bar, 3.14], @enc.deconvert([1, 2, "foo", :bar, 3.14])
      end
    end

    context "ruby request encoder" do
      should "return BERT-RPC encoded request" do
        bert = "\203h\004d\000\004calld\000\005mymodd\000\005myfunh\003a\001a\002a\003"
        assert_equal bert, @enc.encode_ruby_request([:call, :mymod, :myfun, [1, 2, 3]])
      end
    end

    context "bert response decoder" do
      should "return response when reply" do
        req = @enc.encode_ruby_request([:reply, [1, 2, 3]])
        res = @enc.decode_bert_response(req)
        assert_equal [1, 2, 3], res
      end

      should "return nil when noreply" do
        req = @enc.encode_ruby_request([:noreply])
        res = @enc.decode_bert_response(req)
        assert_equal nil, res
      end

      should "raise a ProtocolError error when protocol level error is returned" do
        req = @enc.encode_ruby_request([:error, [:protocol, 1, "invalid"]])
        assert_raises(BERTRPC::ProtocolError) do
          @enc.decode_bert_response(req)
        end
      end

      should "raise a ServerError error when server level error is returned" do
        req = @enc.encode_ruby_request([:error, [:server, 1, "invalid"]])
        assert_raises(BERTRPC::ServerError) do
          @enc.decode_bert_response(req)
        end
      end

      should "raise a UserError error when user level error is returned" do
        req = @enc.encode_ruby_request([:error, [:user, 1, "invalid"]])
        assert_raises(BERTRPC::UserError) do
          @enc.decode_bert_response(req)
        end
      end

      should "raise a ProxyError error when proxy level error is returned" do
        req = @enc.encode_ruby_request([:error, [:proxy, 1, "invalid"]])
        assert_raises(BERTRPC::ProxyError) do
          @enc.decode_bert_response(req)
        end
      end
    end
  end
end