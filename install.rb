FileUtils.cp File.join(File.dirname(__FILE__), 'public/javascripts/globalize_translator.js'),  File.join(File.dirname(__FILE__), '../../../public/javascripts')
FileUtils.cp File.join(File.dirname(__FILE__), 'public/stylesheets/globalize_translator.css'), File.join(File.dirname(__FILE__), '../../../public/stylesheets')
puts IO.read(File.join(File.dirname(__FILE__), 'README'))