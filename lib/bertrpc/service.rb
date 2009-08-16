module BERTRPC
  class Service
    attr_accessor :host, :port

    def initialize(host, port)
      @host = host
      @port = port
    end

    def call
      Request.new(self, :call)
    end

    def cast
      Request.new(self, :cast)
    end
  end
end