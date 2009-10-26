module BERTRPC
  # Taken with love from memcache-client.
  # See http://is.gd/4CWRA
  class BufferedIO < Net::BufferedIO # :nodoc:
    BUFSIZE = 1024 * 16

    if RUBY_VERSION < '1.9.1'
      def rbuf_fill
        begin
          @rbuf << @io.read_nonblock(BUFSIZE)
        rescue Errno::EWOULDBLOCK
          retry unless @read_timeout
          if IO.select([@io], nil, nil, @read_timeout)
            retry
          else
            raise Timeout::Error, 'IO timeout'
          end
        end
      end
    end

    def setsockopt(*args)
      @io.setsockopt(*args)
    end
  end
end
