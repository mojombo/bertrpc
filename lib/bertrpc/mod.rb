module BERTRPC
  class Mod
    def initialize(svc, req, mod)
      @svc = svc
      @req = req
      @mod = mod
    end

    def method_missing(cmd, *args)
      args = [*args]
      Action.new(@svc, @req, @mod, cmd, args).execute
    end
  end
end