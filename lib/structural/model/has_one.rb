module Structural
  module Model
    class HasOne < Association
      def value_of(data)
        child = data.fetch(key, &default_value)
        type.new(child) unless child.nil?
      end
    end
  end
end
