# Run a bunch of blocks isolated. Useful when a rake task as to launch many 
# Usage:
#   results = IsolatedBlock.run(task1: -> { 1 + 1 }, task2: -> { raise 'error' })
#   result[:task1] # => 2
#   result[:task2] # => RuntimeError
module IsolatedBlocks
  def self.run(tasks)
    tasks.reduce({}) do |result, (name, block)|
      begin
        result[name] = block.call
      rescue StandardError => exception
        result[name] = exception
      end
      result
    end
  end
end
