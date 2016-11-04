module Structural
  module Model
    attr_reader :data

    def initialize(data = {})
      @data = Hashifier.hashify(data)
    end

    def set(values)
      self.class.new(data.merge(Hashifier.hashify(values)))
    end

    def unset(*keys)
      self.class.new(data.except(*keys.map(&:to_sym)))
    end

    def eql? other
      other.is_a?(Structural::Model) && other.data.eql?(self.data)
    end
    alias_method :==, :eql?

    def hash
      data.hash
    end

    private

    def self.included(base)
      base.extend(Descriptor)
    end

    def memoize(ivar, &b)
      instance_variable_get(ivar) || instance_variable_set(ivar, b.call(data))
    end
  end
end
