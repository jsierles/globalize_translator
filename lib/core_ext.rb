module ActionView
  module Helpers
    module JavaScriptMacrosHelper
      def in_place_editor(field_id, options = {})
        function =  "new Ajax.InPlaceEditor(" 
        function << "'#{field_id}', " 
        function << "'#{url_for(options[:url])}'" 

        js_options = {}
        js_options['cancelText'] = %('#{options[:cancel_text]}') if options[:cancel_text]
        js_options['okText'] = %('#{options[:save_text]}') if options[:save_text]
        js_options['loadingText'] = %('#{options[:loading_text]}') if options[:loading_text]
        js_options['rows'] = options[:rows] if options[:rows]
        js_options['cols'] = options[:cols] if options[:cols]
        js_options['externalControl'] = options[:external_control] if options[:external_control]
        js_options['loadTextURL'] = "'#{options[:load_text_url]}'" if options[:load_text_url]
        js_options['clickToEditText'] = %('#{options[:click_to_edit_text]}') if options[:click_to_edit_text]
        js_options['ajaxOptions'] = options[:options] if options[:options]
        js_options['callback']   = "function(form) { return #{options[:with]} }" if options[:with]
        function << (', ' + options_for_javascript(js_options)) unless js_options.empty?

        function << ')'

        javascript_tag(function)
      end
    end
  end
end