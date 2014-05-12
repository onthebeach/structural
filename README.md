# Structural

`Structural` is a cut down fork of `Id`, designed to work with `Ruby >= 1.8.7` and
`Rails >= 2.3`.

#### Defining a model

    class MyModel
      include Structural::Model

      field :foo
      field :bar, default: 42
      field :baz, key: 'barry'
    end

    my_model = MyModel.new(foo: 7, barry: 'hello')
    my_model.foo # => 7
    my_model.bar # => 42
    my_model.baz # => 'hello'

Default values can be specified, as well as key aliases.

#### Associations

We can also specify `has_one` or `has_many` associations for nested documents:

    class Zoo
      include Structural::Model

      has_many :lions
      has_many :zebras
      has_one :zookeeper, type: Person
    end

    zoo = Zoo.new(lions: [{name: 'Hetty'}],
                  zebras: [{name: 'Lisa'}],
                  zookeeper: {name: 'Russell' d})

    zoo.lions.first.class # => Lion
    zoo.lions.first.name  # => "Hetty"
    zoo.zookeeper.class   # => Person
    zoo.zookeeper.name    # => "Russell"

Types are inferred from the association name unless one is specified.

#### Designed for immutability

`structural` models provide accessor methods, but no mutator methods.
When changing the value of a field, a new copy of the object is created:

    person = Person.new(name: 'Russell', job: 'programmer')
    person.set(name: 'Radek')
    # => returns a new Person whose name is Radek and whose job is 'programmer'
    person.hat.set(colour: 'red')
    # => returns a new person object with a new hat object with its colour set to red
