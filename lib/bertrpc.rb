require 'bert'
require 'socket'
require 'net/protocol'

require 'bertrpc/service'
require 'bertrpc/request'
require 'bertrpc/mod'
require 'bertrpc/encodes'
require 'bertrpc/action'
require 'bertrpc/errors'

module BERTRPC
  def self.version
    File.read(File.join(File.dirname(__FILE__), *%w[.. VERSION])).chomp
  rescue
    'unknown'
  end

  VERSION = self.version
end