module Structural
  class Hashifier
    def self.hashify(data)
      {}.tap do |hash|
        data.each do |key, value|
          hash[key.to_sym] = as_data(value)
        end
      end
    end

    def self.as_data(v)
      case v
      when Structural::Model then v.data
      when Array then v.first.is_a?(Structural::Model) ? v.map(&:data) : v
      when Hash then Hashifier.hashify(v)
      else v end
    end
  end
end
