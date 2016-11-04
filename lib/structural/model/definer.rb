module Structural
  module Model
    class Definer
      def self.method_memoize(context, name, &value_block)
        context.class_eval do
          define_method(name) do
            memoize(name, &value_block)
          end
        end
      end

      def self.method(context, name, &value_block)
        context.class_eval do
          define_method(name) do
            value_block.call(self)
          end
        end
      end
    end
  end
end
