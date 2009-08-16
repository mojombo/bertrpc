require 'test_helper'

class ModTest < Test::Unit::TestCase
  context "A Mod" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
      @req = @svc.call
    end

    should "be created with a Service, request and module name" do
      assert BERTRPC::Mod.new(@svc, @req, :mymod).is_a?(BERTRPC::Mod)
    end
  end

  context "A Mod instance" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
      @req = @svc.call
      @mod = BERTRPC::Mod.new(@svc, @req, :mymod)
    end

    should "call execute on the type" do
      m = mock(:execute => nil)
      BERTRPC::Action.expects(:new).with(@svc, @req, :mymod, :myfun, [1, 2, 3]).returns(m)
      @mod.myfun(1, 2, 3)

      m = mock(:execute => nil)
      BERTRPC::Action.expects(:new).with(@svc, @req, :mymod, :myfun, [1]).returns(m)
      @mod.myfun(1)
    end
  end
end