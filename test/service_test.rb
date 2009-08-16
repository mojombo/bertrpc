require 'test_helper'

class ServiceTest < Test::Unit::TestCase
  context "A Service" do
    should "be created with host and port" do
      svc = BERTRPC::Service.new('localhost', 9941)
      assert svc.is_a?(BERTRPC::Service)
    end
  end

  context "A Service Instance's" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
    end

    context "accessors" do
      should "return it's host" do
        assert_equal 'localhost', @svc.host
      end

      should "return it's port" do
        assert_equal 9941, @svc.port
      end
    end

    context "call method" do
      should "return a call type Request" do
        req = @svc.call
        assert req.is_a?(BERTRPC::Request)
        assert_equal :call, req.kind
      end
    end

    context "cast method" do
      should "return a cast type Request" do
        req = @svc.cast
        assert req.is_a?(BERTRPC::Request)
        assert_equal :cast, req.kind
      end
    end
  end
end