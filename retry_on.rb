# Retry a given block when the specified exception has been raised.
# Reraise exception if all attempts fail.
module Kernel
  def retry_on(exception_type, limit = 1, &block)
    attempt_count = 0
    begin
      block.call(attempt_count)
    rescue exception_type => ex
      (attempt_count += 1) <= limit ? retry : raise
    end
  end
end

# A quick test.
if $PROGRAM_NAME == __FILE__
  try_count = 0
  retry_on(RuntimeError, 2) { raise 'Error' if (try_count += 1) < 2 }
  puts 2 == try_count

  begin
    retry_on(RuntimeError) { raise 'Error' }
  rescue RuntimeError
    puts true
  end
end

