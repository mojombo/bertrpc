require 'test_helper'

class RequestTest < Test::Unit::TestCase
  context "A Request" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
    end

    should "be created with a Service and type" do
      assert BERTRPC::Request.new(@svc, :call, nil).is_a?(BERTRPC::Request)
    end
  end

  context "A Request instance" do
    setup do
      svc = BERTRPC::Service.new('localhost', 9941)
      @req = BERTRPC::Request.new(@svc, :call, nil)
    end

    should "return a Mod instance" do
      assert @req.myfun.is_a?(BERTRPC::Mod)
    end
  end
end