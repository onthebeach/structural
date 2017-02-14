module Structural
  module Model
    class HasOne < Association
      def value_of(data)
        child = data.fetch(key, &default_value)
        type.new(child) unless child.nil?
      end

      def default
        value = super

        if value.is_a? Hash
          value
        else
          raise Structural::InvalidDefaultTypeError
        end
      end
    end
  end
end
