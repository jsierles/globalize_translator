class GlobalizeTranslatorError < StandardError; end
class GlobalizeTranslatorArgumentError < GlobalizeTranslatorError; end
class GlobalizeTranslatorUnknownMethod < GlobalizeTranslatorError; end

module GlobalizeTranslator
  class ControllerMethods
    def self.add_routes
      ActionController::Routing::Routes.add_route '/globalize_translator/:action/:id', :controller => 'globalize_translator', :action => 'index', :id => nil
    end
  end
end

module GlobalizeTranslatorHelper

  def select_for_translator
    html = '<div><form method="get"><select id="language" name="locale">' +
    options_for_select(::Globalize::Language.select_options, ::Globalize::Locale.language_code ) +
    '</select><button name="translator" value="true">Change Language</button></form></div>'
    (controller.disable_translator?(controller.globalize_translator_options)) ? "" : html
  end

  def includes_for_translator
    values = ::Globalize.request_translations.to_json
    includes = javascript_tag("current_locale = '#{::Globalize::Locale.language_code}'; translations = " + values) +
    javascript_include_tag('lowpro') +
    javascript_include_tag('/pt_window/javascripts/window') +
    stylesheet_link_tag('/pt_window/themes/default') +
    stylesheet_link_tag('/pt_window/themes/alphacube') +
    stylesheet_link_tag('translator') +
    javascript_include_tag('globalize_translator')
    (controller.disable_translator?(controller.globalize_translator_options)) ? "" : includes
  end
end

ActionView::Base.send(:include, GlobalizeTranslatorHelper)


ActionController::Base.class_eval do
  class_inheritable_reader :globalize_translator_options
  class_inheritable_reader :translation_mode
  before_filter :append_globalize_translator
  
  def self.globalize_translator(options = {})
    raise GlobalizeTranslatorUnknownMethod if options[:if] && (!respond_to?(options[:if].to_sym) || !options[:if].is_a?(Proc))
    write_inheritable_hash :globalize_translator_options, options
  end 

  def disable_translator?(options = nil)
    return true unless options
    request.xhr? || (!params[:format].blank? && params[:format] != 'html') ||
      (options[:only] && ![options[:only]].flatten.collect(&:to_s).include?(action_name)) ||
      (options[:except] && [options[:except]].flatten.collect(&:to_s).include?(action_name)) || (options[:if] and !send(options[:if]))
  end

  def translator_switch_locale
    redirect_to :back
  end

  protected
    def append_globalize_translator
      options = globalize_translator_options
      if disable_translator?(options)
        ::Globalize.translation_mode = false
        return true
      end
      #::Globalize::DbViewTranslator.instance.cache_reset
      ::Globalize.request_translations = [] # reset translations
      ::Globalize.translation_mode = true
      session[:return_to] = request.request_uri unless params[:controller] == 'globalize_translator'
    end

end