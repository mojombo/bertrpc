require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'mocha/test_unit'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'bertrpc'

class Enc
  include BERTRPC::Encodes
end
