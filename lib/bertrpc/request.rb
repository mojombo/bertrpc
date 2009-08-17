module BERTRPC
  class Request
    attr_accessor :kind, :options

    def initialize(svc, kind, options)
      @svc = svc
      @kind = kind
      @options = options
    end

    def method_missing(cmd, *args)
      Mod.new(@svc, self, cmd)
    end
  end
end