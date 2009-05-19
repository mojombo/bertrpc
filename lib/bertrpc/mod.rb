module BERTRPC
  class Mod
    def initialize(svc, mod)
      @svc = svc
      @mod = mod
    end

    def method_missing(cmd, *args)
      Fun.new(@svc, @mod, cmd)
    end
  end
end