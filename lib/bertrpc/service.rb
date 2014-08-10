module BERTRPC
  class Service
    attr_accessor :host, :port, :timeout, :connect_timeout

    def initialize(host, port, timeout = nil, connect_timeout = nil)
      @host = host
      @port = port
      @timeout = timeout
      @connect_timeout = connect_timeout
    end

    def call(options = nil)
      verify_options(options)
      Request.new(self, :call, options)
    end

    def cast(options = nil)
      verify_options(options)
      Request.new(self, :cast, options)
    end

    # private

    def verify_options(options)
      if options
        if cache = options[:cache]
          unless cache[0] == :validation && cache[1].is_a?(String)
            raise InvalidOption.new("Valid :cache args are [:validation, String]")
          end
        else
          raise InvalidOption.new("Valid options are :cache")
        end
      end
    end
  end
end
