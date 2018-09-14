# frozen_string_literal: true
require 'minitest'
require 'jeweler/container'
require 'jeweler/duplicate_definition_error'

class ContainerTest < Minitest::Test
  def test_creates_object_from_alias
    container = Jeweler::Container.new(
      'my_object' => {
        'class' => 'String',
        'args' => ['one']
      }
    )
    result = container['my_object']
    assert_instance_of(String, result)
    assert_equal('one', result)
  end

  def test_raises_undefined_error
    assert_raises(Jeweler::UndefinedError) do
      container = Jeweler::Container.new({
        'one' => {
          'class' => 'String',
          'args' => ['one']
        }
      })
      container['two']
      flunk('An exception should be raised if a definition is not found.')
    end
  end

  def test_raises_duplicate_definition_error
    assert_raises(Jeweler::DuplicateDefinitionError) do
      Jeweler::Container.new({
                               1 => {
                                 'class' => 'String',
                                 'args' => ['one']
                               },
                               2 => {
                                 'class' => 'String',
                                 'args' => ['two']
                               }
                             })
      flunk('Duplicate definitions should raise an Error')
    end
  end

  def test_creates_object_from_reference
    container = Jeweler::Container.new(
      'one' => {
        'class' => 'String',
        'args' => ['one']
      },
      'two' => {
        'class' => 'String',
        'args' => ['@one']
      }
    )
    result = container['two']
    assert_instance_of(String, result)
    assert_equal('one', result)
  end

  def test_always_creates_new_instance
    container = Jeweler::Container.new(
      'one' => {
        'class' => 'String',
        'args' => ['one']
      }
    )
    instance = container['one']
    refute_equal(instance.object_id, container['one'])
  end
end
