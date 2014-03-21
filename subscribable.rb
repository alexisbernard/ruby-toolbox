module Subscribable
  def subscribed_blocks
    @subscribed_blocks ||= {}
  end

  def subscribe(name, method = nil, &block)
    (subscribed_blocks[name] ||= []) << (method || block)
  end

  def publish(name, *args)
    blocks = subscribed_blocks[name] and blocks.each { |block| block.call(*args) }
  end
end

if $PROGRAM_NAME == __FILE__
  $call_count = 0
  string = "This test must print 2 lines if it passes."
  string.extend(Subscribable)
  string.publish(:foo, "This text should not be printed.")

  def bar(arg)
    puts arg
    $call_count += 1
  end

  string.subscribe(:foo) { |arg| puts arg; $call_count += 1 }
  string.subscribe(:foo, method(:bar))
  string.publish(:foo, "This text must be printed 2 times.")

  raise "Fail" if $call_count != 2
end
