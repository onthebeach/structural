module Structural
  module Model
    module TypeCasts

      def self.cast(type, value)
        if value.is_a?(type)
          value
        else
          casts.fetch(type, Identity).cast(value)
        end
      end

      def self.register(cast)
        casts[cast.type] = cast
      end

      private

      def self.casts
        @casts ||= {}
      end

      class Identity
        def self.type
          ::Identity
        end

        def self.cast(value)
          value
        end
      end

      class Integer
        def self.type
          ::Integer
        end

        def self.cast(value)
          value.to_i
        end

        TypeCasts.register(self)
      end

      class Float
        def self.type
          ::Float
        end

        def self.cast(value)
          value.to_f
        end

        TypeCasts.register(self)
      end

      class Date
        def self.type
          ::Date
        end

        def self.cast(value)
          ::Date.parse value
        end

        TypeCasts.register(self)
      end

      class Time
        def self.type
          ::Time
        end

        def self.cast(value)
          ::Time.parse value
        end

        TypeCasts.register(self)
      end

      class Money
        def self.type
          ::Money
        end

        def self.cast(value)
          ::Money.new value.to_i
        end

        TypeCasts.register(self)
      end
    end
  end
end
