# rm -rfv some_crazy_app; rails new some_crazy_app -T -J --database=postgresql -m basic.rb

# require 'rubygems'
# require 'mark_facets'
# require 'erb'

# puts ARGV.inspect
# puts options.inspect
# puts self.inspect

source_paths << File.join(File.dirname(__FILE__), 'sub_templates')

apply('rvm.rb')

apply('clean_public_folder.rb') # clean up public folder crap

apply('database.rb')

apply('assets.rb')

apply('jquery.rb')

apply('application.js.rb')

apply('application.rb')

apply('rspec.rb') # run before other gems to ensure they can add to the spec_helper.rb file.

apply('layouts.rb')

apply('application_helper.rb') # needs to access rspec

apply('application_controller.rb') # needs to access rspec

apply('gems.rb')

apply('plugins.rb')

apply('home.rb')

apply('mail.rb')

apply('heroku.rb')