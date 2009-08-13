module BERTRPC
  class CallProxy
    def initialize(svc)
      @svc = svc
    end

    def method_missing(cmd, *args)
      Mod.new(@svc, Call, cmd)
    end
  end
end