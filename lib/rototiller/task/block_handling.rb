module Rototiller
  module Task
    module BlockHandling

      class BlockSyntax

        def initialize(param_array)
          self.class.class_eval { param_array.each do |i|
            # define attribute setters for each param array. these are used
            attr_writer   i
            # define attribute getters with arguments for the nested attributes of the same name who receive args as hashes
            #   these will not be used as the hash args are stripped off when we yield to the parent (caller)
            define_method("#{i}") { |arg = nil| }
          end
          }
        end

        def to_h
          h = Hash.new
          self.instance_variables.each do |var|
            h[var.to_s.delete('@').to_sym] = self.instance_variable_get(var)
          end
          h
        end
      end

      # creates a hash of attributes from a block and array of parameter names
      #   that match method calls in the block
      # @param [Array<Symbol>] param_array the parameters to pull from the block
      # for block { |b| ... }
      # @yield object with attributes matching param_array
      # @return [Hash] hash of param_array keys and their values from the block
      def pull_params_from_block(param_array, &block)
        block_syntax_obj = BlockSyntax.new(param_array)
        yield(block_syntax_obj)
        block_syntax_obj.to_h
      end

    end
  end
end
