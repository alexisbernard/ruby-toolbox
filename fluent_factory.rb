# -*- encoding : utf-8 -*-
# Fluent Factory overrides the new class method to provide an intuitive factory.
# Instead of using
#  MyFactory.new_instance(args)
# Which may return an instance of MyClass, you now use
#  MyClass.new(args)
# The second way is more intuitive and the big advantage is to use it rails and
# inheritance.
# 
# Read the full example below to understand how to use it.
#    class Animal
#      include FluentFactory
#
#      def self.args_to_class(*args, &block)
#        return if not args.first.is_a?(String)
#        case args.first.downcase
#        when /garfield/ then Cat
#        when /bucephalus/ then Horse
#        when /snoopy/ then Dog
#        end
#      end
#
#      def initialize(name)
#        @name = name
#      end
#    end
#
#    class Dog < Animal; end
#    class Cat < Animal; end
#    class Horse < Animal; end
#
#    puts Animal.new('snoopy').class # => Dog
#    puts Animal.new('garfield').class # => Cat
#    puts Animal.new('bucephalus').class # => Horse
module Fluent
  module Factory
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      # Create a new instance of the relevant type from the specified arguments.
      # If no relevant type is found, then the base new method is called.
      def new(*args, &block)
        if klass = args_to_class(*args, &block)
          instance = klass.allocate
          instance.__send__(:initialize, *args, &block)
          instance
        else
          super(*args)
        end
      end
      
      # The class receiving FluentFactory have to define this method. The job of this
      # method is to return the relevant class from the specified arguments.
      def args_to_class(*args, &block)
        raise NotImplementedError.new('You have to define this class method to return the relevant class.')
      end
    end
  end
end

# A quick test.
if $PROGRAM_NAME == __FILE__
  class Animal
    include Fluent::Factory
    
    def self.args_to_class(*args, &block)
      return if not args.first.is_a?(String)
      case args.first.downcase
      when /garfield/ then Cat
      when /bucephalus/ then Horse
      when /snoopy/ then Dog
      end
    end

    def initialize(name)
      @name = name
    end
  end
  
  class Dog < Animal; end
  class Cat < Animal; end
  class Horse < Animal; end
  
  raise 'Failed' if Animal.new('snoopy').class != Dog
  raise 'Failed' if Animal.new('garfield').class != Cat
  raise 'Failed' if Animal.new('bucephalus').class != Horse
  puts 'Fluent::Factory works.'
end
