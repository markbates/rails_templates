gem 'mark_facets'

inject_into_file('spec/spec_helper.rb', :after => "require 'rspec/rails'\n") do
<<-FILE
require 'mark_facets/rails/test'
FILE
end