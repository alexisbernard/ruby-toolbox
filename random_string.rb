class RandomString
  DEFAULT_LENGTH = 16
  DEFAULT_CHARS = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).freeze

  attr_reader :length, :chars

  def self.roll(length = DEFAULT_LENGTH, chars = DEFAULT_CHARS)
    new(length, chars).roll
  end

  def initialize(length = DEFAULT_LENGTH, chars = DEFAULT_CHARS)
    @length = length
    @chars = chars
  end

  def roll
    (1..length).reduce('') { |str, i| str << chars[rand(chars.length)] }
  end
end

if $PROGRAM_NAME == __FILE__
  raise "16" if RandomString.roll.size != 16
  raise "Different" if RandomString.roll == RandomString.roll
end
