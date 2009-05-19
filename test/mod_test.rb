require 'test_helper'

class ModTest < Test::Unit::TestCase
  context "A Mod" do
    setup do
      @svc = BERTRPC::Service.new('localhost', 9941)
    end

    should "be created with a Service and module name" do
      assert BERTRPC::Mod.new(@svc, :mymod).is_a?(BERTRPC::Mod)
    end
  end

  context "A Mod instance" do
    setup do
      svc = BERTRPC::Service.new('localhost', 9941)
      @mod = BERTRPC::Mod.new(@svc, :mymod)
    end

    should "return a Fun instance" do
      assert @mod.myfun.is_a?(BERTRPC::Fun)
    end
  end
end