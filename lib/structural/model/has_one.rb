module Structural
  module Model
    class HasOne < Association
      def value_of(data)
        child = data.fetch(key, &default_value)
        type.new(child) unless child.nil?
      end

      def default
        valid_type_check(super)
      end

      private

      def valid_type_check(v)
        case v
        when Hash then v
        when Proc then valid_type_check(v.call)
        else raise Structural::InvalidDefaultTypeError end
      end
    end
  end
end
