require 'spec_helper'

class NestedModel
  include Structural::Model
  field :yak
  field :name, :default => nil
  field :surname, :default => nil
end

class SeparateClass
  def self.as_hash
    { :name => 'Michael' }
  end
end

class TestModel
  include Structural::Model

  field :foo
  field :bar, :key => 'baz'
  field :nested_hash
  field :quux, :default => false
  field :date_of_birth, :type => Date
  field :empty_date, :type => Date
  field :christmas, :default => Date.new(2014,12,25), :type => Date
  field :time_stamp, :type => Time

  has_one :aliased_model, :type => NestedModel
  has_one :nested_model, :key => 'aliased_model'
  has_one :extra_nested_model
  has_one :nested_with_invalid_default, :default => nil
  has_one :nested_with_hash_default, :default => { name: 'Michael' }, :type => NestedModel
  has_one :nested_with_hash_proc_default, :default => Proc.new { SeparateClass.as_hash }, :type => NestedModel
  has_one :nested_with_invalid_proc_default, :default => Proc.new { SeparateClass.new }, :type => NestedModel
  has_one :missing_nested_without_default
  has_one :test_model
  has_many :nested_models

  class ExtraNestedModel
    include Structural::Model
    field :cats
  end
end

describe Structural::Model do
  let(:model) do
    TestModel.new(
      :foo => 3,
      :baz => 6,
      :quxx => 8,
      :nested_hash => {1 => :one, 2 => :two},
      :test_model => {},
      :date_of_birth => '06-06-1983',
      :aliased_model => {'yak' => 11},
      :nested_models => [{'yak' => 11}, {:yak => 14}],
      :extra_nested_model => { :cats => "MIAOW" },
      :time_stamp => '2015-01-27T13:13:13+00:00'
    )
  end


  describe ".new" do
    it 'converts any passed Structural models to their hash representations' do
      new_model = TestModel.new(:test_model => model)
      new_model.test_model.data.should eq model.data
    end
  end

  describe ".field" do
    it 'defines an accessor on the model' do
      model.foo.should eq 3
    end

    it 'allows key aliases' do
      model.bar.should eq 6
    end

    it 'allows default values' do
      model.quux.should eql(false)
    end

    it 'leaves nested hashes unmodified' do
      model.nested_hash.should eql({1 => :one, 2 => :two})
    end

    describe "typecast option" do
      it 'typecasts to the provided type if a cast exists' do
        model.date_of_birth.should be_a Date
        model.christmas.should be_a Date
      end

      it 'parses the date correctly' do
        model.date_of_birth.should eql Date.new(1983, 6, 6)
      end

      it 'parses the time correctly' do
        model.time_stamp.should eql Time.new(2015, 1, 27, 13, 13, 13, '+00:00')
      end
    end
  end

  describe ".has_one" do
    it 'allows nested models' do
      model.aliased_model.should be_a NestedModel
    end

    it 'allows nested models' do
      model.nested_model.should be_a NestedModel
      model.nested_model.yak.should eq 11
    end

    it 'allows associations to be nested within the class' do
      model.extra_nested_model.should be_a TestModel::ExtraNestedModel
      model.extra_nested_model.cats.should eq 'MIAOW'
    end

    it 'allows recursively defined models' do
      model.test_model.should be_a TestModel
    end

    it 'allows default values as a hash' do
      model.nested_with_hash_default.name.should eq 'Michael'
      model.nested_with_hash_default.surname.should be_nil
    end

    context 'when passing a Proc as a default' do
      it 'allows the default' do
        model.nested_with_hash_proc_default.name.should eq 'Michael'
        model.nested_with_hash_default.surname.should be_nil
      end

      context 'when the Proc does not return a Hash' do
        it 'raises an error' do
          expect {
            model.nested_with_invalid_proc_default
          }.to raise_error(Structural::InvalidDefaultTypeError)
        end
      end
    end

    it 'fails if passed a non-hash as default' do
      expect {
        model.nested_with_invalid_default
      }.to raise_error(Structural::InvalidDefaultTypeError)
    end

    it 'fails for missing associations without defaults' do
      expect {
        model.missing_nested_without_default
      }.to raise_error(Structural::MissingAttributeError)
    end
  end

  describe ".has_many" do
    it 'creates an array of nested models' do
      model.nested_models.should be_a Array
      model.nested_models.first.should be_a NestedModel
      model.nested_models.first.yak.should eq 11
      model.nested_models.last.yak.should eq 14
    end
  end

  describe "#set" do
    it "creates a new model with the provided values changed" do
      model.set(:foo => 999).should be_a TestModel
      model.set(:foo => 999).foo.should eq 999
    end
  end

  describe "#unset" do
    it 'returns a new basket minus the passed key' do
      expect { model.set(:foo => 999, :bar => 555).unset(:foo, :bar).foo }.to raise_error Structural::MissingAttributeError, "foo"
    end

    it 'does not error if the key to be removed does not exist' do
      expect { model.unset(:not_in_hash) }.to_not raise_error
    end
  end

  describe "#fields are present methods" do
    it 'allows you to check if fields are present' do
      model = TestModel.new(:foo => 1)
      model.foo?.should eql(true)
      model.bar?.should eql(false)
    end
  end

  describe "#==" do
    it 'is equal to another Structural model with the same data' do
      one = TestModel.new(:foo => 1)
      two = TestModel.new(:foo => 1)
      one.should eq two
    end

    it 'is not equal to two models with different data' do
      one = TestModel.new(:foo => 1)
      two = TestModel.new(:foo => 2)
      one.should_not eq two
    end
  end

  describe "#hash" do
    it 'allows Structural models to be used as hash keys' do
      one = TestModel.new(:foo => 1)
      two = TestModel.new(:foo => 1)
      hash = { one => :found }
      hash[two].should eq :found
    end
    it 'they are different keys if the data is different' do
      one = TestModel.new(:foo => 1)
      two = TestModel.new(:foo => 2)
      hash = { one => :found }
      hash[two].should be_nil
      hash[one].should eq :found
    end
  end

  describe "#to_proc" do
    it 'eta expands the model class into its constructor' do
      [{},{}].map(&TestModel).all? { |m| m.is_a? TestModel }.should eql(true)
    end
  end
end
