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

    gem install mojombo-bertrpc -s http://gems.github.com


Example
-------

    require 'bertrpc'
    
    svc = BERTRPC::Service.new('localhost', 9999)
    svc.calc.add.call([1, 2])
    # => 3


Copyright
---------

Copyright (c) 2009 Tom Preston-Werner. See LICENSE for details.
