require 'find'

namespace :globalize do
  desc "Copies the latest translator assets to the application's public directory"
  task :update_translator_assets do
    puts "Copying assets.."
    FileUtils.cp File.join(File.dirname(__FILE__), '../public/javascripts/globalize_translator.js'),  File.join(RAILS_ROOT, 'public', 'javascripts')
    FileUtils.cp File.join(File.dirname(__FILE__), '../public/javascripts/lowpro.js'),  File.join(RAILS_ROOT, 'public', 'javascripts')
    FileUtils.cp File.join(File.dirname(__FILE__), '../public/stylesheets/translator.css'),  File.join(RAILS_ROOT, 'public', 'stylesheets')
      
    pt_window_target = File.join(File.join(RAILS_ROOT, 'public', 'pt_window'))
    FileUtils.rm_r pt_window_target if File.exists?(pt_window_target)
    FileUtils.cp_r(File.join(File.dirname(__FILE__), '../public/pt_window'), pt_window_target)
    Find.find(pt_window_target) do |f| 
        FileUtils.rm_rf(f) if /\.svn$/ =~ f 
      end
  end
  desc 'Run Globalize Translator tests'
  Rake::TestTask.new do |t|
    t.test_files = FileList["#{File.dirname( __FILE__ )}/../test/*_test.rb"]
    t.verbose = true
  end
end
