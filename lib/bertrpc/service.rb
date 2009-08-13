module BERTRPC
  class Service
    attr_accessor :host, :port

    def initialize(host, port)
      @host = host
      @port = port
    end

    def call
      CallProxy.new(self)
    end
  end
end