# rm -rfv some_crazy_app; rails new some_crazy_app -T -J --database=postgresql -m basic.rb

require 'rubygems'
require 'mark_facets'
require 'erb'

# puts ARGV.inspect
# puts options.inspect
# puts self.inspect

source_paths << File.join(File.dirname(__FILE__), 'sub_templates')

apply('clean_public_folder.rb') # clean up public folder crap

apply('database.rb')

apply('assets.rb')

apply('jquery.rb') # jquery

apply('application.rb')

apply('layouts.rb')

apply('gems.rb')

apply('plugins.rb')

apply('heroku.rb')