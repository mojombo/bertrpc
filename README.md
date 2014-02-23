BERTRPC
=======

By Tom Preston-Werner (tom@mojombo.com)

BERT-RPC client library for Ruby. Makes it ridiculously simple to interface
with BERT-RPC servers.

See the full BERT-RPC specification at [bert-rpc.org](http://bert-rpc.org).

This library currently only supports the following BERT-RPC features:

* `call` requests
* `cast` requests

BERTRPC was developed for GitHub and is currently in production use performing
millions of RPC requests every day. The stability and performance have been
exemplary.


Installation
------------

    $ gem install bertrpc


Examples
--------

Require the library and create a service:

    require 'bertrpc'
    svc = BERTRPC::Service.new('localhost', 9999)

Make a call:

    svc.call.calc.add(1, 2)
    # => 3

The underlying BERT-RPC transaction of the above call is:

    -> {call, calc, add, [1, 2]}
    <- {reply, 3}

Make a cast:

    svc.cast.stats.incr
    # => nil

The underlying BERT-RPC transaction of the above cast is:

    -> {cast, stats, incr, []}
    <- {noreply}


Documentation
-------------

Creating a service:

    # No timeout
    svc = BERTRPC::Service.new('localhost', 9999)
    
    # 10s socket read timeout, raises BERTRPC::ReadTimeoutError
    svc = BERTRPC::Service.new('localhost', 9999, 10)


Copyright
---------

Copyright (c) 2009 Tom Preston-Werner. See LICENSE for details.
