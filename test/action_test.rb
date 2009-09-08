require 'test_helper'

class ActionTest < Test::Unit::TestCase
  context "An Action" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
      @req = @svc.call
    end

    should "be created with a Service, module name, fun name, and args" do
      assert BERTRPC::Action.new(@svc, @req, :mymod, :myfun, [1, 2]).is_a?(BERTRPC::Action)
    end
  end

  context "An Action instance" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
      @req = @svc.call
      @enc = Enc.new
    end

    should "call with single-arity" do
      req = @enc.encode_ruby_request([:call, :mymod, :myfun, [1]])
      res = @enc.encode_ruby_request([:reply, 2])
      call = BERTRPC::Action.new(@svc, @req, :mymod, :myfun, [1])
      call.expects(:transaction).with(req).returns(res)
      assert_equal 2, call.execute
    end

    should "call with single-arity array" do
      req = @enc.encode_ruby_request([:call, :mymod, :myfun, [[1, 2, 3]]])
      res = @enc.encode_ruby_request([:reply, [4, 5, 6]])
      call = BERTRPC::Action.new(@svc, @req, :mymod, :myfun, [[1, 2, 3]])
      call.expects(:transaction).with(req).returns(res)
      assert_equal [4, 5, 6], call.execute
    end

    should "call with multi-arity" do
      req = @enc.encode_ruby_request([:call, :mymod, :myfun, [1, 2, 3]])
      res = @enc.encode_ruby_request([:reply, [4, 5, 6]])
      call = BERTRPC::Action.new(@svc, @req, :mymod, :myfun, [1, 2, 3])
      call.expects(:transaction).with(req).returns(res)
      assert_equal [4, 5, 6], call.execute
    end

    context "sync_request" do
      setup do
        @svc = BERTRPC::Service.new('localhost', 9941)
        @req = @svc.call
        @call = BERTRPC::Action.new(@svc, @req, :mymod, :myfun, [])
      end
    
      should "read and write BERT-Ps from the socket" do
        io = stub()
        io.expects(:write).with("\000\000\000\003")
        io.expects(:write).with("foo")
        io.expects(:read).with(4).returns("\000\000\000\003")
        io.expects(:read).with(3).returns("bar")
        io.expects(:close)
        TCPSocket.expects(:new).returns(io)
        assert_equal "bar", @call.transaction("foo")
      end

      should "raise a ProtocolError when the length is invalid" do
        io = stub()
        io.expects(:write).with("\000\000\000\003")
        io.expects(:write).with("foo")
        io.expects(:read).with(4).returns(nil)
        TCPSocket.expects(:new).returns(io)
        begin
          @call.transaction("foo")
          fail "Should have thrown an error"
        rescue BERTRPC::ProtocolError => e
          assert_equal 0, e.code
        end
      end
      
      should "raise a ProtocolError when the data is invalid" do
        io = stub()
        io.expects(:write).with("\000\000\000\003")
        io.expects(:write).with("foo")
        io.expects(:read).with(4).returns("\000\000\000\003")
        io.expects(:read).with(3).returns(nil)
        TCPSocket.expects(:new).returns(io)
         begin
          @call.transaction("foo")
          fail "Should have thrown an error"
        rescue BERTRPC::ProtocolError => e
          assert_equal 1, e.code
        end
      end
    end
  end
end