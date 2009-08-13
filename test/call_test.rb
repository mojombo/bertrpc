require 'test_helper'

class CallTest < Test::Unit::TestCase
  context "A Call" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
    end

    should "be created with a Service, module name, fun name, and args" do
      assert BERTRPC::Call.new(@svc, :mymod, :myfun, [1, 2]).is_a?(BERTRPC::Call)
    end
  end

  context "A Call instance" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
      @enc = Enc.new
    end

    should "call with single-arity" do
      req = @enc.encode_ruby_request([:call, :mymod, :myfun, [1]])
      res = @enc.encode_ruby_request([:reply, 2])
      call = BERTRPC::Call.new(@svc, :mymod, :myfun, [1])
      call.expects(:sync_request).with(req).returns(res)
      assert_equal 2, call.execute
    end

    should "call with single-arity array" do
      req = @enc.encode_ruby_request([:call, :mymod, :myfun, [[1, 2, 3]]])
      res = @enc.encode_ruby_request([:reply, [4, 5, 6]])
      call = BERTRPC::Call.new(@svc, :mymod, :myfun, [[1, 2, 3]])
      call.expects(:sync_request).with(req).returns(res)
      assert_equal [4, 5, 6], call.execute
    end

    should "call with multi-arity" do
      req = @enc.encode_ruby_request([:call, :mymod, :myfun, [1, 2, 3]])
      res = @enc.encode_ruby_request([:reply, [4, 5, 6]])
      call = BERTRPC::Call.new(@svc, :mymod, :myfun, [1, 2, 3])
      call.expects(:sync_request).with(req).returns(res)
      assert_equal [4, 5, 6], call.execute
    end

    context "sync_request" do
      setup do
        @svc = BERTRPC::Service.new('localhost', 9941)
        @call = BERTRPC::Call.new(@svc, :mymod, :myfun, [])
      end
    
      should "read and write BERT-Ps from the socket" do
        io = stub()
        io.expects(:write).with("\000\000\000\003")
        io.expects(:write).with("foo")
        io.expects(:read).with(4).returns("\000\000\000\003")
        io.expects(:read).with(3).returns("bar")
        io.expects(:close)
        TCPSocket.expects(:new).returns(io)
        assert_equal "bar", @call.sync_request("foo")
      end

      should "raise a ProtocolError when the length is invalid" do
        io = stub()
        io.expects(:write).with("\000\000\000\003")
        io.expects(:write).with("foo")
        io.expects(:read).with(4).returns(nil)
        TCPSocket.expects(:new).returns(io)
        assert_raises(BERTRPC::ProtocolError) do
          @call.sync_request("foo")
        end
      end
      
      should "raise a ProtocolError when the data is invalid" do
        io = stub()
        io.expects(:write).with("\000\000\000\003")
        io.expects(:write).with("foo")
        io.expects(:read).with(4).returns("\000\000\000\003")
        io.expects(:read).with(3).returns(nil)
        TCPSocket.expects(:new).returns(io)
        assert_raises(BERTRPC::ProtocolError) do
          @call.sync_request("foo")
        end
      end
    end
  end
end