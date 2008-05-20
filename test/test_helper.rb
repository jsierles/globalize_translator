GLOBALIZE_PATH = File.join(File.dirname(__FILE__), "/../../globalize")
require GLOBALIZE_PATH + '/test/test_helper'

class Test::Unit::TestCase
  
  def assert_difference(object, method = nil, difference = 1, *args)
    initial_value = object.send(method, *args)
    yield
    assert_equal initial_value + difference, object.send(method, *args), "#{object}##{method}"
  end

  def assert_no_difference(object, method, *args, &block)
    assert_difference object, method, 0, *args, &block
  end

end

# load up Globalize Translator
require File.join(File.dirname(__FILE__), '..', 'init')

#ActionController::Base.send :globalize_translator, :on => true

#class TestController < ActionController::Base
#  def index
#  end
#end