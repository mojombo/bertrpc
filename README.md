BERTRPC
=======

By Tom Preston-Werner (tom@mojombo.com)

WARNING: This software is alpha and should not be used in production without
extensive testing. You should not consider this project production ready until
it is released as 1.0.


Description
-----------

BERTRPC is a Ruby BERT-RPC client library.


Installation
------------

From GemCutter:

    gem install bertrpc

From GitHub:

    gem install mojombo-bertrpc -s http://gems.github.com \
                                -s http://gemcutter.org


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


Copyright
---------

Copyright (c) 2009 Tom Preston-Werner. See LICENSE for details.
