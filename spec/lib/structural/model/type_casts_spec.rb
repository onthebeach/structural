require 'spec_helper'

module Structural
  module Model
    module TypeCasts
      describe Integer do
        subject { Integer.cast("2") }

        it 'casts strings to integers' do
          expect(subject).to eql(2)
        end
      end

      describe Float do
        subject { Float.cast("2.0") }

        it 'casts strings to floats' do
          expect(subject).to eql(2.0)
        end
      end

      describe Date do
        it 'casts strings to dates' do
          Date.cast("06-06-1983").should eq ::Date.new(1983, 6, 6)
        end
      end

      describe Time do
        it 'casts strings to Times' do
          Time.cast("06-06-1983").should eq ::Time.parse("06-06-1983")
        end
      end

      describe Money do
        it 'ints or strings to Money' do
          Money.cast("500").should eq ::Money.new(5_00)
          Money.cast(500).should eq ::Money.new(5_00)
        end
      end
    end
  end
end
