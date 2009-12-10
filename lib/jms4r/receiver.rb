
module JMS
  class Receiver
    attr_accessor :receiver, :parent

    def initialize(parent, qname, sel=nil)
      @parent = parent
      @sess = parent.sess
      @receiver = @sess.createReceiver(parent.queue(qname), sel)
    end

    def while_receive(timeout)
      prc =
        if(timeout == 0)
          lambda {|t| @receiver.receive() }
        elsif timeout.nil?
          lambda {|t| @receiver.receiveNoWait() }
        else
          lambda {|t| @receiver.receive(t) }
        end
      while msg=prc.call(timeout)
        yield(msg)
      end
    end

    def method_missing(*args)
      @receiver.__send__ *args
    end

  end
end

