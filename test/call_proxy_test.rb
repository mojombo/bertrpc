require 'test_helper'

class CallProxyTest < Test::Unit::TestCase
  context "A CallProxy" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
    end

    should "be created with a Service" do
      assert BERTRPC::CallProxy.new(@svc).is_a?(BERTRPC::CallProxy)
    end
  end

  context "A CallProxy instance" do
    setup do
      svc = BERTRPC::Service.new('localhost', 9941)
      @cp = BERTRPC::CallProxy.new(@svc)
    end

    should "return a Mod instance" do
      assert @cp.myfun.is_a?(BERTRPC::Mod)
    end
  end
end