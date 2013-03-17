# -*- encoding : utf-8 -*-

require 'open3'

class Coquille

  # Run a shell command and returns true or raise a Coquille::Error if returned code is not zero.
  # Untrusted strings, must be passed as separated argument in order to be escaped to prevent from security issues.
  #   user_input = 'directory; rm -Rf /'
  #   Coquille.run!('ls ?', user_input) # => Prevent from removing all files.
  def self.run!(command, *args)
    Open3.popen3(sanitize(command, *args)) do |stdin, stdout, stderr, thread|
      raise Error.new(command, stdout, stderr, thread) if thread.value != 0
    end
    true
  end

  def self.sanitize(string, *array)
    string.gsub('?') { quote(array.shift) }
  end

  # Surround within single quotes because there is no dollar, back quotes and back slash interpretations.
  def self.quote(string)
    "'" + string.gsub("'") { "'\\''" } + "'"
  end

  class Error < StandardError
    attr_reader :command, :stdout, :stderr, :thread
    def initialize(command, stdout, stderr, thread)
      @command, @stdout, @stderr, @thread = command, stdout.read, stderr.read, thread.value
      super({command: command, stdout: stdout, stderr: stderr, exit: thread}.inspect)
    end
  end

end
