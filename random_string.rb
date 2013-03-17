module RandomString
  DEFAULT_LENGTH = 16
  DEFAULT_CHARS = (('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a).freeze

  def self.roll(length = DEFAULT_LENGTH, chars = DEFAULT_CHARS)
    if block_given?
      loop { yield(token = roll(chars, length)) or return token }
    else
      (1..length).reduce('') { |str, i| str << chars[rand(chars.length)] }
    end
  end
end