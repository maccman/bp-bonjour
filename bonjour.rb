# $: << File.join(File.dirname(__FILE__), *%w[net-mdns lib])
# 
# # For MDNSSD
# require 'net/dns/mdns-sd'
# # To make Resolv aware of mDNS
# require 'net/dns/resolv-mdns'
# # To make TCPSocket use Resolv, not the C library resolver.
# require 'net/dns/resolv-replace'

bp_require File.join(*%w[net-mdns lib net dns mdns-sd])
# bp_require File.join(*%w[net-mdns lib net dns resolv-mdns])
# bp_require File.join(*%w[net-mdns lib net dns resolv-replace])

DNSSD = Net::DNS::MDNSSD

class Bonjour
  def initialize(args)
  end
  
  def browse(bp, args)
    Thread.new(bp, args) do |bp, args|
      service = DNSSD.browse(args['service']) do |b|
        DNSSD.resolve(b.name, b.type) do |r|
          args['callback'].invoke(r.name, r.target, r.port)
        end
      end
      sleep(args['timeout'] || 3)
      service.stop
      bp.complete(true)
    end
  end
  
  def register(bp, args)
    DNSSD.register(args['name'], args['service'], 'local', args['port'])
    bp.complete(true)
  end
end

# http://browserplus.yahoo.com/developer/services/ruby/
rubyCoreletDefinition = {
  'class' => "Bonjour",
  'name' => "Bonjour",
  'major_version' => 1,
  'minor_version' => 0,
  'micro_version' => 0,
  'documentation' => 'A todo service that tests callbacks from ruby.',
  'functions' =>
  [
    {
      'name' => 'browse',
      'documentation' => "Sayt todo \"hello\" to the world",
      'arguments' =>
      [
        {
          'name' => 'service',
          'type' => 'string',
          'required' => true,
          'documentation' => 'the callback to send a hello message to'
        },
        {
          'name' => 'callback',
          'type' => 'callback',
          'required' => true,
          'documentation' => 'the callback to send a hello message to'
        },
        {
          'name' => 'timeout',
          'type' => 'integer',
          'required' => false,
          'documentation' => 'the callback to send a hello message to'
        }
      ]
    },
    {
      'name' => 'register',
      'documentation' => "todo",
      'arguments' => 
      [
        {
          'name' => 'name',
          'type' => 'string',
          'required' => true,
          'documentation' => 'todo'
        },
        {
          'name' => 'service',
          'type' => 'string',
          'required' => true,
          'documentation' => 'todo'
        },
        {
          'name' => 'port',
          'type' => 'integer',
          'required' => true,
          'documentation' => 'todo'
        }
      ]
    }
  ] 
}