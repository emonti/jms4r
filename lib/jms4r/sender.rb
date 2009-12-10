module JMS
  class Sender
    attr_accessor :sender, :parent

    def initialize(parent, qname)
      @parent = parent
      @sess   = parent.sess
      @sender = @sess.createSender(parent.queue(qname))
    end

    def send_message(msg)
      @sender.send(@parent.create_msg(msg))
    end

    def method_missing(*args)
      @sender.__send__(*args)
    end
  end
end

