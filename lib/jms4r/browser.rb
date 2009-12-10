require 'enumerator'

module JMS
  class Browser
    attr_accessor :browser, :parent

    def initialize(parent, qname, sel=nil)
      @parent = parent
      @sess = parent.sess
      @browser = @sess.createBrowser(parent.queue(qname), sel)
    end

    def each_message
      enum = @browser.getEnumeration()
      yield(enum.nextElement) while enum.hasMoreElements
    end

    def messages
      self.to_enum(:each_message).to_a
    end
  end

  def method_missing(*args)
    @browser.__send__(*args)
  end
end

