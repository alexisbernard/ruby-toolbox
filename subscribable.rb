module Subscribable
  def subscribed_callbacks
    @subscribed_callbacks ||= {}
  end

  def subscribe(name, method = nil, &block)
    (subscribed_callbacks[name] ||= []) << (method || block)
  end

  def publish(name, *args)
    subscribed_callbacks[name].each { |block| block.call(*args) }
  end
end

if $PROGRAM_NAME == __FILE__
  puts string = "This test must print 2 lines if it passes."
  string.extend(Subscribable)

  def bar(arg)
    puts arg
  end

  string.subscribe(:foo) { |arg| puts arg }
  string.subscribe(:foo, method(:bar))
  string.publish(:foo, "Test")
end
