require 'dispatcher'
require 'globalize_ext'
require 'core_ext'
require 'globalize_translator'

Dispatcher.to_prepare :globalize_translator_route do
  ::GlobalizeTranslator::ControllerMethods.add_routes
end

controller_path = File.join(RAILS_ROOT, 'vendor/plugins/globalize_translator/controllers')
$LOAD_PATH << controller_path
Dependencies.load_paths << controller_path
