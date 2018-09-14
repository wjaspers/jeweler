# frozen_string_literal: true

require 'jeweler/duplicate_definition_error'
require 'jeweler/undefined_error'

module Jeweler
  # !@attribute definitions
  class Container
    # Defines the prefix the container uses to identify references to other container objects.
    # @const [String]
    REFERENCE_CHARACTER = '@'

    # @param [Hash] definitions
    def initialize(definitions = {})
      self.definitions = definitions
    end

    # Calls the lambda defined for class or alias +name+, which should return an object.
    # @param [String] name
    # @return [Object]
    # @raise [UndefinedError]
    def build(name)
      return @definitions[name].call if definition?(name)

      raise UndefinedError, "No container definition for #{name}"
    end

    # Allow the caller to access instances by array literal syntax
    alias [] build

    private

    # @param [String]
    # @return [Object|nil]
    def build_reference(name)
      build(name[1..-1])
    end

    # @param [Hash] definition
    # @return [Lambda]
    def create_factory_lambda(definition) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      lambda do
        klass = definition['class']
        arguments = definition['args']
        if arguments.is_a?(Hash)
          arguments.each do |key, arg|
            arguments[key] = build_reference(arg) if reference?(arg)
          end
        elsif arguments.is_a?(Array)
          arguments.each_with_index do |arg, index|
            arguments[index] = build_reference(arg) if reference?(arg)
          end
        end
        Object.const_get(klass).method(:new).call(*arguments)
      end
    end

    # Generates a map of lambdas used to create instances from definitions.
    # @param [Hash] map
    # @raise [ArgumentError]
    # @raise [Jeweler::DuplicateDefinitionError]
    def definitions=(map)
      raise ArgumentError, 'Definitions must be a hash.' unless map.is_a?(Hash)

      @definitions = {}
      map.each do |name, definition|
        name = definition['class'] if name.is_a?(Integer) || name.nil? || name =~ /^$/
        raise Jeweler::DuplicateDefinitionError, 'Alias already defined!' if definition?(name)

        @definitions[name] = create_factory_lambda(definition)
      end
    end

    # Asks if a definition for +name+ exists.
    # @param [String] name
    # @return [bool]
    def definition?(name)
      @definitions.key?(name)
    end

    # Determines if +name+ is an alias to a container definition.
    # This is only used for swapping strings with arguments during construction.
    # @param [String] name
    # @return [bool]
    def reference?(name)
      name.start_with?(REFERENCE_CHARACTER)
    end
  end
end
