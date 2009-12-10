
module JMS

  # Stolen pretty much verbatim from the jmesnil-jms4r JBoss JMS implementation.
  #
  # This is a general purpose javax.jms.MessageListener implementation
  # which just passes messages to a block in the 'onMessage' handler.
  #
  # Usage:
  #
  #   require "pp"
  #   # assuming consumer is a java.jmx.MessageConsumer...
  #   consumer.message_listener = JMS::Listener.new do |msg|
  #     pp [:text_msg,  msg.text] if msg.respond_to? :text
  #   end
  #
  class Listener
    include javax.jms.MessageListener
 
    def initialize(&handler)
      @handler = handler
    end
 
    def on_message message
      @handler.call(message)
    end
  end

end

