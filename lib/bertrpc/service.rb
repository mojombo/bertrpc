module BERTRPC
  class Service
    attr_accessor :host, :port

    def initialize(host, port)
      @host = host
      @port = port
    end

    def method_missing(cmd, *args)
      Mod.new(self, cmd)
    end
  end
end