gem 'mark_facets', :git => 'git://github.com/markbates/mark_facets.git'

inject_into_file('spec/spec_helper.rb', :after => "require 'rspec/rails'\n") do
<<-FILE
require 'mark_facets/rails/test'
FILE
end