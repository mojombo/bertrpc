require 'test_helper'

class ErrorTest < Test::Unit::TestCase
  context "Errors in general" do
    should "concatenate remote and local backtraces" do
      begin
        raise BERTRPC::BERTRPCError.new('msg', 'Error', ['foo', 'bar'])
      rescue Object => e
        assert_equal ['---REMOTE---', 'foo', 'bar', '---LOCAL---'], e.backtrace[0..3]
      end
    end
  end
end