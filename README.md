---
# Jeweler

A lightweight dependency injection container for ruby projects.

## License
*MIT* License. Do whatever makes sense.

## Installation
bundle require 'jeweler'

## Usage
```ruby
require 'jeweler'
container = Jeweler::Container.new(definitions)
```

### As a map
```ruby
container = Jeweler::Container.new({
  'my_object_alias' => {
    'class' => 'String',
    'args' => ['Hello, world.']
  }
})

container['my_object_alias'] # 'Hello, world.'
```

### As an array
```ruby
container = Jeweler::Container.new([
  {
    'class' => 'String',
    'args' => ['Hello, world.']
  },
  {
    'class' => 'Object',
    'args' => []
  }
])

container['String'] # 'Hello, world.'
container['Object'] # '#<Object:0x007fc3cb95d9e0>' 
```

### From yaml
```ruby
require 'yaml'

container = Jeweler::Container.new(YAML.load(File.join('.', 'config', 'definitions.yml')))
container['one'] # 'Hello, world.'
```

### With references
```ruby
container = Jeweler::Container.new({
  'one' => {
    'class' => 'String',
    'args' => ['Hello, world.']
  },
  'two' => {
    'class' => 'String',
    'args' => ['@one']
  }
})

container['two'] # 'Hello, world.' 
```
