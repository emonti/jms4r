
module JMS
  class Receiver
    attr_accessor :receiver, :parent

    def initialize(parent, qname, sel=nil)
      @parent = parent
      @sess = parent.sess
      @receiver = @sess.createReceiver(parent.queue(qname), sel)
    end

    def while_receive(timeout)
      while msg=@receiver.receive(timeout)
        yield(msg)
      end
    end

    def method_missing(*args)
      @receiver.__send__ *args
    end

  end
end

