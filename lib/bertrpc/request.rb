module BERTRPC
  class Request
    attr_accessor :kind

    def initialize(svc, kind)
      @svc = svc
      @kind = kind
    end

    def method_missing(cmd, *args)
      Mod.new(@svc, self, cmd)
    end
  end
end