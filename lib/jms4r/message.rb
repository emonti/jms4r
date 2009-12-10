 
module JMS
  include_class 'javax.jms.Message'

  module Message
    def props
      @props ||= Properties.new(self)
    end

    class Properties
      include Enumerable 

      def initialize(msg)
        @msg = msg
      end
      
      def each_key(&block)
        @msg.getPropertyNames().each &block
      end

      def <=> (a,b)
        a[0] <=> b[0]
      end

      def each(&block)
        each_key {|k| yield(k, @msg.getObjectProperty(k)) }
       end
       
      def keys
        @msg.getPropertyNames().to_a
      end

      def [](key)
        @msg.getObjectProperty(key)
      end
      
      def []=(k, v)
        @msg.setObjectProperty(k, v)
      end
      
      def size
        keys.size
      end
    end

  end
end
