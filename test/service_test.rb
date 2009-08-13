require 'test_helper'

class ServiceTest < Test::Unit::TestCase
  context "A Service" do
    should "be created with host and port" do
      svc = BERTRPC::Service.new('localhost', 9941)
      assert svc.is_a?(BERTRPC::Service)
    end
  end

  context "A Service Instance" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
    end

    should "return it's host" do
      assert_equal 'localhost', @svc.host
    end

    should "return it's port" do
      assert_equal 9941, @svc.port
    end

    should "return a Call instance" do
      assert @svc.call.is_a?(BERTRPC::CallProxy)
    end
  end
end