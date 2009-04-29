bp_require File.join(*%w[net-mdns lib net dns mdns-sd])
Thread.abort_on_exception = true
DNSSD = Net::DNS::MDNSSD

class Bonjour
  def initialize(args)
  end
  
  def browse(bp, args)
    service = DNSSD.browse(args['service']) do |b|
      DNSSD.resolve(b.name, b.type) do |r|
        log(r.target)
        log(r.port)
        # next if same host
        next if r.target == Socket.gethostname
        args['callback'].invoke(
          b.name, 
          r.target, 
          r.port
        )
      end
    end
    sleep(args['timeout'] || 3)
    service.stop
    bp.complete(true)
  end
  
  def register(bp, args)
    DNSSD.register(args['name'], args['service'], 'local', args['port'])
    bp.complete(true)
  end
  
  private
    def log(d)
      bp_log("info", d.inspect)
    end
end

# http://browserplus.yahoo.com/developer/services/ruby/
rubyCoreletDefinition = {
  'class' => "Bonjour",
  'name' => "Bonjour",
  'major_version' => 1,
  'minor_version' => 0,
  'micro_version' => 5,
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