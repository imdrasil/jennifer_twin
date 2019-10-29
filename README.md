# JenniferTwin [![Latest Release](https://img.shields.io/github/release/imdrasil/jennifer_twin.svg)](https://github.com/imdrasil/jennifer_twin/releases)

Super simple library to dump/load [Jennifer](https://github.com/imdrasil/jennifer.cr) model attributes to plain class instance to be able to integrate it with any kind of hidden attributes.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  jennifer_twin:
    github: imdrasil/jennifer_twin
    version: 0.1.0
```

2. Run `shards install`

## Usage

Jennifer generates some amount of hidden attributes for a mode to be able to track whether attribute has been changed, relation load state or just a collection, etc. For some tasks you would like to have an instance containing only model attributes or it's subset. One of the most popular example - `JSON::Serializable`. Therefor JenniferTwin copies all data from original instance and store them.

> If you trying to solve issue of model serialization to JSON - take a look at [Serializer](https://github.com/imdrasil/serializer).

To create a **twin** include `JenniferTwin` and call `.map_fields` macro:

```crystal
require "jennifer_twin"

class UserTwin
  map_fields User
end
```

### Mapping

`.map_fields` macro generates only 3 things:

- getters for fields named after model's ones (unless other name is specified)
- initializer accepting model instance to copy
- `#to_model` method to create a model instance from it's fields

```crystal
user = User.all.first
user_twin = UserTwin.new(user)
user_twin.to_model # => User
```

As a 2nd argument macro accepts named tuple or symbol-based hash of field options. Supported options are:

- `:ignore` - if set to `true` ignores specified field
- `:key` - defines attribute with the specified value

Let's take a look at more descriptive example:

```crystal
class User < Jennifer::Model::Base
  mapping(
    id: Primary32,
    name: String?,
    age: Int32?,
    password_hash: String?
  )
end

class UserTwin
  include JenniferTwin
  include JSON::Serializable

  map_fields(User, {
    name: { key: :full_name },
    password_hash: { ignore: true }
  })

  setter full_name

  @[JSON::Field(emit_null: true)]
  @age : Int32?
end

user = User.all.first # <User:0x000000000010 id: 1, name: "User 8", age: nil, password_hash: "<hash>">
user_twin = UserTwin.new(user) # <UserTwin:0x000000000020 @id=1, @full_name="User 8", @age=nil>
user_twin.to_json # => %({"id":1,"full_name":"User 8","age":null})

user_twin.full_name = "New Name"
user_twin.to_modal # <User:0x000000000030 id: nil, name: "New Name", age: nil, password_hash: nil>
```

As you see to define any custom annotation you need to redefine field.

Also you can add additional custom logic to generated initializer passing a block to the macro call. To access model instance use `record` variable name.

```crystal
class UserTwin
  include JenniferTwin

  getter full_name : String

  map_fields(User) do
    @full_name = "#{record.name} Snow"
  end
end
```

## Contributing

1. Fork it (<https://github.com/imdrasil/jennifer_twin/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Roman Kalnytskyi](https://github.com/imdrasil) - creator and maintainer
