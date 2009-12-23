#!/usr/bin/env jruby

Dir['jars/*.jar'].each {|x| require(x) }

require 'jms4r'

module ActiveMQ
  include JMS

  class Session < AbstractSession

    attr_accessor :ctx

    def init_session(host, port, env = nil)
      e = java.util.Hashtable.new
      e.put( javax.naming.Context.INITIAL_CONTEXT_FACTORY,
            'org.apache.activemq.jndi.ActiveMQInitialContextFactory' )
      e.put( javax.naming.Context.PROVIDER_URL,
             "tcp://#{host}:#{port}")

      env.each {|k,v| e.put(k, v)} if env

      @ctx = javax.naming.InitialContext.new(e)
      @factory = @ctx.lookup("ConnectionFactory")
      @conn = @factory.createConnection()
      @sess = @conn.createSession(false, javax.jms.Session::AUTO_ACKNOWLEDGE)
    end

    def lookup(n)
      @ctx.lookup(n)
    end

    def list(n)
      @ctx.list(n).to_a
    end
  end
end


if __FILE__ == $0
  require 'irb'

  unless host=ARGV.shift 
    STDERR.puts "Usage: #{File.basename $0} host [port] [queue]"
    exit 1
  end

  port = ARGV.shift || 61616
  qname = ARGV.shift || 'loopback_test'

  @rcv, @snd, @brws = nil
  @sess = ActiveMQ::Session.new('192.168.11.70', port.to_i) do |this|
    @snd = this.create_sender(qname)
    @brws = this.create_browser(qname)
    @rcv = this.create_receiver(qname)
  end

  STDERR.puts "@sess = #{@sess.inspect}",
              "@rcv = #{@rcv.inspect}",
              "@snd = #{@snd.inspect}",
              "@brws= #{@brws.inspect}"
  IRB.start

end

