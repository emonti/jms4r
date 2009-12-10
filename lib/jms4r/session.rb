
module JMS
  class AbstractSession
    attr_reader :conn, :sess

    # Creates a new instance of the implemented Session and calls the start
    # method on the connection. Arguments are passed directly to 
    # 'init_session'. See init_session for more information.
    #
    # Optionally yields(self) to a block if one is given.
    def initialize(*args)
      init_session(*args)
      yield(self) if block_given?
      @conn.start()
    end

    # This is an abstract method and must be defined in implementing classes.
    # This method is called from 'new' to establish the @conn and @sess 
    # connection/session instance variables before anything else.
    #
    # Don't call super()!
    def init_session(*args)
      raise NotImplementedError, 
        "#{self.class}.init_session is unimplemented or the abstract was "+
        "called with super(). Override this in your implementation."
    end

    # You may override this if you wish to perform any additional teardown 
    # steps, but be sure to call super().
    #
    # The method may be called when instance variables are nil or already
    # closed and must ensure a No-OP for these cases.
    def close
      @sess.close if @sess
      @conn.close if @conn
    end

    # This method is called to resolve a queue name string to a Queue object 
    # suitable for passing as an argument to various JMS API functions.
    #
    # Some implementations may want to override this to return a Destination
    # instead, depending on the underlying JMS implementation.
    def queue(qname)
      @sess.createQueue(qname)
    end

    # This method is called to resolve a topic name string to a Topic object 
    # suitable for passing as an argument to various JMS API functions.
    #
    # Some implementations may want to override this to return a Destination
    # instead, depending on the underlying JMS implementation.
    def topic(tname)
      @sess.createTopic(tname)
    end

    # Creates a JMS Sender for a given queue which is
    # used to put messages on the queue.
    #
    # Most implementations take only one argument:
    #   qname: The name of the queue.
    def create_sender(*args)
      ::JMS::Sender.new(self, *args)
    end

    # Creates a JMS Receiver for a given queue which is used to 'consume'
    # or "receive and remove" messages from the queue.
    #
    # Most implementations take two arguments:
    #   qname: The name of the queue.
    #   sel: an optional 'message selector' string.
    def create_receiver(*args)
      ::JMS::Receiver.new(self, *args)
    end

    # Creates a JMS Receiver for a given queue.
    #
    # Most implementations take two arguments:
    #   qname: The name of the queue.
    #   sel: an optional 'message selector' string.
    def create_browser(*args)
      ::JMS::Browser.new(self, *args)
    end

    # Attempts to compose a populated JMS message typed based on msg type.
    # Returns the message after it has been created (and populated with msg
    # data). In some cases, you may want finer grained control, in which case, 
    # use the JMS @sess object directly to compose messages instead.
    #
    # * If msg is nil, an empty 'Message' containing only headers is returned.
    # * Pass a Ruby String, a TextMessage is returned.
    # * For a ByteMessage, either pass a Java::byte[] object directly or 
    #   {:bytes => [...]}. A ByteMessage is returned.
    # * Pass a Ruby Hash a MapMessage is returned.
    # * For all other objects, if they are java.io.Serializable, an 
    #   ObjectMessage is returned.
    # 
    # In all other cases, an ArgumentError will be raised.
    def create_msg(msg=nil)
      m=nil

      case msg
      when nil
        m = @sess.createMessage()

      when String
        m = @sess.createTextMessage(msg)

      when ( msg.kind_of?(Java::byte[]) or 
             (msg.kind_of?(Hash) and msg.keys == [:bytes]) )
        m = @sess.createBytesMessage
        if b.kind_of? Java::byte[]
          m.readBytes(b)
        elsif (bs=b[:bytes]).kind_of? Array
          m.readBytes(bs.to_java(:byte))
        else
          raise(ArgumentError, "invalid argument for java byte[] array")
        end

      when Hash
        m = @sess.createMapMessage
        msg.each {|k,v| m.setObject(k.to_s, v)}

      when msg.kind_of?(java.io.Serializable)
        m = @sess.createObjectMessage(msg)
      else 
        raise(ArgumentError, "Can't handle #{msg.class} msg objects")
      end
      return m
    end
  end

end
