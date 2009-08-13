module BERTRPC
  class Mod
    def initialize(svc, type, mod)
      @svc = svc
      @type = type
      @mod = mod
    end

    def method_missing(cmd, *args)
      args = [*args]
      @type.new(@svc, @mod, cmd, args).execute
    end
  end
end