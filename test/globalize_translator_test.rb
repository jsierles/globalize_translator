require File.dirname(__FILE__) + '/test_helper'

class GlobalizeTranslatorTest < Test::Unit::TestCase

  class RenderController < ActionController::Base
    def test() render :action => 'test'; end
    def rescue_action(e) raise; end
  end

  RenderController.prepend_view_path(GLOBALIZE_PATH + "/test/views")

  def setup
    @controller = ::GlobalizeTranslatorController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @c_class = @controller.class
    
    ::GlobalizeTranslator::ControllerMethods.add_routes
    @c_class.globalize_translator :on => true
  end
 
# TODO - get rendering tests working on 1.2 and edge  
#  class RenderControllerTest < Test::Unit::TestCase
#    include Globalize
#    fixtures :globalize_languages, :globalize_countries
#
#   def setup
#      Locale.set("en-US")
#      @controller = RenderController.new
#      @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
#    end

#    def test_rendered_action
#      get :test
#      assert @response.rendered_with_file?
#      assert 'test', @response.rendered_file
#      assert_template 'test'
#    end
# end
  
  
begin
  def test_should_raise_exception_for_unknown_method_condition
    assert_raise(GlobalizeTranslatorUnknownMethod) do
      @c_class.globalize_translator :on => true, :if => :gibberish!
    end
  end
end
  
  def test_should_set_locale
    @c_class.globalize_translator :on => true, :set_locale => true
  end
  
  def test_should_not_set_locale
    @c_class.globalize_translator :on => true, :set_locale => false    
  end

  def test_should_reset_view_translation_cache
   #get :index
   #assert_equal 0, ::Globalize::Locale.translator.cache_size
  end
  
end
