require 'test_helper'

class ErrorTest < Test::Unit::TestCase
  context "Errors in general" do
    should "be creatable with just a message string" do
      begin
        raise BERTRPC::BERTRPCError.new('msg')
      rescue Object => e
        assert_equal "msg", e.message
        assert_equal 0, e.code
      end
    end

    should "be creatable with a [code, message] array" do
      begin
        raise BERTRPC::BERTRPCError.new([7, 'msg'])
      rescue Object => e
        assert_equal "msg", e.message
        assert_equal 7, e.code
      end
    end

    should "record the original exception" do
      begin
        raise BERTRPC::BERTRPCError.new('msg', 'Error', ['foo', 'bar'])
      rescue Object => e
        assert_equal "msg", e.message
        assert_equal "Error: msg", e.original_exception.message
        assert_equal ['foo', 'bar'], e.original_exception.backtrace
      end
    end
  end
end