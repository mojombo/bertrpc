require 'test_helper'

class FunTest < Test::Unit::TestCase
  context "A Fun" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
    end

    should "be created with a Service, module name, and fun name" do
      assert BERTRPC::Fun.new(@svc, :mymod, :myfun).is_a?(BERTRPC::Fun)
    end
  end

  context "A Fun instance" do
    setup do
      svc = BERTRPC::Service.new('localhost', 9941)
      @fun = BERTRPC::Fun.new(svc, :mymod, :myfun)
    end

    should "call with single-arity" do
      req = @fun.encode_ruby_request([:call, :mymod, :myfun, [1]])
      res = @fun.encode_ruby_request([:reply, 2])
      @fun.expects(:sync_request).with(req).returns(res)
      assert_equal 2, @fun.call(1)
    end

    should "call with single-arity array" do
      req = @fun.encode_ruby_request([:call, :mymod, :myfun, [[1, 2, 3]]])
      res = @fun.encode_ruby_request([:reply, [4, 5, 6]])
      @fun.expects(:sync_request).with(req).returns(res)
      assert_equal [4, 5, 6], @fun.call([1, 2, 3])
    end

    should "call with multi-arity" do
      req = @fun.encode_ruby_request([:call, :mymod, :myfun, [1, 2, 3]])
      res = @fun.encode_ruby_request([:reply, [4, 5, 6]])
      @fun.expects(:sync_request).with(req).returns(res)
      assert_equal [4, 5, 6], @fun.call(1, 2, 3)
    end

    context "converter" do
      should "convert top level hashes to BERT-RPC dict form" do
        assert_equal([:dict, [:foo, 1], [:bar, 2]], @fun.convert({:foo => 1, :bar => 2}))
      end

      should "convert nested hashes in the same way" do
        assert_equal([1, 2, [:dict, [:foo, 1]]], @fun.convert([1, 2, {:foo => 1}]))
      end

      should "keep everything else the same" do
        assert_equal [1, 2, "foo", :bar, 3.14], @fun.convert([1, 2, "foo", :bar, 3.14])
      end
    end

    context "deconverter" do
      should "convert top level BERT-RPC dict forms to hashes" do
        assert_equal({:foo => 1, :bar => 2}, @fun.deconvert([:dict, [:foo, 1], [:bar, 2]]))
      end

      should "convert nested dicts in the same way" do
        assert_equal([1, 2, {:foo => 1}], @fun.deconvert([1, 2, [:dict, [:foo, 1]]]))
      end

      should "keep everything else the same" do
        assert_equal [1, 2, "foo", :bar, 3.14], @fun.deconvert([1, 2, "foo", :bar, 3.14])
      end
    end

    context "sync_request" do
      should "read and write BERT-Ps from the socket" do
        io = stub()
        io.expects(:write).with("\000\000\000\003")
        io.expects(:write).with("foo")
        io.expects(:read).with(4).returns("\000\000\000\003")
        io.expects(:read).with(3).returns("bar")
        io.expects(:close)
        TCPSocket.expects(:new).returns(io)
        assert_equal "bar", @fun.sync_request("foo")
      end
    end

    context "ruby request encoder" do
      should "return BERT-RPC encoded request" do
        bert = "\203h\004d\000\004calld\000\005mymodd\000\005myfunh\003a\001a\002a\003"
        assert_equal bert, @fun.encode_ruby_request([:call, :mymod, :myfun, [1, 2, 3]])
      end
    end

    context "bert response decoder" do
      should "return response when successful" do
        req = @fun.encode_ruby_request([:reply, [1, 2, 3]])
        res = @fun.decode_bert_response(req)
        assert_equal [1, 2, 3], res
      end

      should "raise a ProtocolError error when protocol level error is returned" do
        req = @fun.encode_ruby_request([:error, [:protocol, 1, "invalid"]])
        assert_raises(BERTRPC::ProtocolError) do
          @fun.decode_bert_response(req)
        end
      end

      should "raise a ServerError error when server level error is returned" do
        req = @fun.encode_ruby_request([:error, [:server, 1, "invalid"]])
        assert_raises(BERTRPC::ServerError) do
          @fun.decode_bert_response(req)
        end
      end

      should "raise a UserError error when user level error is returned" do
        req = @fun.encode_ruby_request([:error, [:user, 1, "invalid"]])
        assert_raises(BERTRPC::UserError) do
          @fun.decode_bert_response(req)
        end
      end

      should "raise a ProxyError error when proxy level error is returned" do
        req = @fun.encode_ruby_request([:error, [:proxy, 1, "invalid"]])
        assert_raises(BERTRPC::ProxyError) do
          @fun.decode_bert_response(req)
        end
      end
    end
  end
end